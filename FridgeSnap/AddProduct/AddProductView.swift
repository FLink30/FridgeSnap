import SwiftUI
import SwiftData
import AVFoundation
import os

struct AddProductView: View {
    // Logger /////////////////////////
    let logger = Logger()
    
    // SwiftData working context and Query /////////////////////////
    @Environment(\.modelContext) private var context
    @Query var productList: [Product]
    
    // mockScan for development /////////////////////////
    let mockScan: Bool
    
    // Product API /////////////////////////
    let productApi: ProductApi
    
    // Sheets ////////////////////////
    @State private var showingScannerSheet = false
    @State var showingAmountSheet = false
    @State var showingCategorySheet = false
    
    @State var productIsCompleted: Bool = false
    
    // Manual Input via picker and inputField (name) /////////////////////////
    @State var name: String = ""
    @State var productCategoryInput: String = ""
    @State var pickerAmount: Int = 1
    @State var pickerCategory: Category = .other
    @State var pickerUnit: Unit = .count
    
    
    // Displayed values in InputFields /////////////////////////
    @State var displayedCategory: String = ""
    @State var displayedAmountUnit: String = ""
    
    // Product to be loaded from API /////////////////////////
    @State var loadedProduct: ProductDetails? = ProductDetails.MOCK_ProductDetail_full
    
    // product to be added to Swift Data /////////////////////////
    @State var product: Product = Product.MOCK_Product_empty
    
    // Toast and Error ////////////////////////
    @State var errorMessage = "Invalid amount"
    
    // Input Field Focus ////////////////////////
    @FocusState var focusedField: InputType?
    
    // DropdownMenu
    let categories: [Category] = Category.allCases
    // check for authorization for camera /////////////////////////
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            // Determine if the user previously authorized camera access.
            var isAuthorized = status == .authorized
            
            // If the system hasn't determined the user's authorization status,
            // explicitly prompt them for approval.
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            return isAuthorized
        }
    }
    // FancyToastManager from ProductListView /////////////////////////
    @ObservedObject var toastManager: ToastManager

    var body: some View {
        VStack(spacing: Padding.prettySmall()) {
            
            // MARK: - First Row: Button, TextField, Button
            
            HStack {
                
                // Barcode Button /////////////////////////
                CustomButton(type: .icon, disabled: !product.name.isEmpty, image: "barcode", action: {
                    // For Development Reasons depending on mockScan, camera works or getBarCodeProduct fetches concrete product
                    Task{
                        if(mockScan == false){
                            guard await isAuthorized else { return }
                            showingScannerSheet = true
                        }else{
                            await getProductByBarcode(ean: "20011581")
                        }
                    }})

                // Sheet with Scanner /////////////////////////
                .sheet(isPresented: $showingScannerSheet) {
                    //ScannerView wird initialisiert mit Closure onCodeScanned
                    ScannerView { scannedCode in
                        Task{
                            await getProductByBarcode(ean: scannedCode)
                            showingScannerSheet = false // Schließt den Scanner
                        }
                    }
                }

                // TextField for name ////////////////////////////////
                TextField("Product name", text: $name)
                    .padding()
                    .onChange(of: name) { _, value in
                        updateManualInput()
                    }
                
                InputField(text: $displayedCategory,
                           placeholder: "Category",
                           isFocused: _focusedField,
                           fieldType: .category)

                // Button for add Product to List ///////////////////////////
                Button(action: {
                    Task {
                        addProductToList()
                    }
                }) {
                    Image(systemName: "arrow.up.circle")
                        .padding()
                }
            }
            .padding(Padding.large())
            
            // MARK: - Second Row: Foto, TextField, picker sheet
            
            HStack {
                // Foto /////////////////////////
                AsyncImage(url: URL(
                    string: product.imageUrlSmall)) { phase in
                        switch phase {
                        case .empty:
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: Padding.fotoSmall(),
                                       maxHeight: Padding.fotoSmall())
                                .foregroundColor(.gray)
                                .cornerRadius(Padding.small())
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: Padding.fotoSmall(),
                                       maxHeight: Padding.fotoSmall())
                                .cornerRadius(Padding.small())
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: Padding.fotoSmall(),
                                       maxHeight: Padding.fotoSmall())
                                .foregroundColor(.gray)
                                .cornerRadius(Padding.small())
                        @unknown default:
                            fatalError()
                        }
                    }.padding(Padding.medium())
                Spacer(minLength: Padding.medium())
                
                // Amount of product /////////////////////////
                InputField(text:$displayedAmountUnit,

                           placeholder: "Amount",
                           isFocused: _focusedField,
                           fieldType: .amount)
            
                
                // Picker Sheet with Amount and Unit /////////////////////////
                .sheet(isPresented: $showingAmountSheet) {
                    AmountUnitPickerView(pickerAmount: $pickerAmount, pickerUnit: $pickerUnit)
                        .presentationDetents([.fraction(0.3)])
                }
                // Picker Sheet with Category /////////////////////////
                .sheet(isPresented: $showingCategorySheet) {
                    PickerView<Category>(selectedItem: $pickerCategory)
                        .presentationDetents([.fraction(0.3)])
                }
                
                // OnChange of Picker Variables
                .onChange(of: pickerCategory) { _, newCategory in
                    let category = newCategory
                    product.category = category()
                    displayedCategory = category()
                    logger.info("product has category \(self.product.category())")
                }
                .onChange(of: pickerAmount) { _, newAmount in
                    let amount = newAmount
                    product.amount = amount
                    displayedAmountUnit = "\(amount) \(pickerUnit.abbr())"
                    logger.info("product has amount \(self.product.amount )")
                }
                .onChange(of: pickerUnit) { _, newUnit in
                    let unit = newUnit
                    product.unit = unit
                    displayedAmountUnit = "\(pickerAmount) \(unit.abbr())"
        
                    logger.info("product has unit \(self.product.unit())")
                }
                
                // OnChange of Focused InputField
                .onChange(of: focusedField, {
                    _, _ in
                    switch focusedField {
                    case .amount:
                        showingAmountSheet = true
                    case .category:
                        showingCategorySheet = true
                    default:
                        showingAmountSheet = false
                        showingCategorySheet = false
                    }
                })
            }
        }

    }
    
    // get Product by Barcode /////////////////////////
    func getProductByBarcode(ean: String) async {
        do {
            if let loadedProduct = try await productApi.getProductDetails(id: ean) {
                name = loadedProduct.name
                pickerCategory = loadedProduct.categories
                
                //make sure that categorieInputField is current
                displayedCategory = pickerCategory()
                
                let newProduct = Product(apiId: loadedProduct.apiId,

                                         name: loadedProduct.name,
                                         category: loadedProduct.categories(),
                                         brand: loadedProduct.brand,
                                         imageUrlSmall: loadedProduct.imageSmallUrl,
                                         imageUrlBig: loadedProduct.imageUrl,
                                         isBought: false,
                                         amount: 0,
                                         unit: .count)
                product = newProduct

            }
        } catch {
            logger.error("Error \(error) occurred while fetching product with ean: \(ean)")
        }
    }
    // update Product with Manual Input /////////////////////////
    func updateManualInput() {
        product.name = name
        if product.apiId == ""{
            product.apiId = UUID().uuidString

        }
    }
    
    // add Product to List /////////////////////////
    func addProductToList() {

        if name == "" {
            toastManager.show(type: .info)
        } else if !productList.contains(where: { 
            //apiId check for barcode, nameCheck for manual Input
            $0.apiId == product.apiId || $0.name == product.name }) {
            toastManager.show(type: .success)
            let newProduct = Product(apiId: product.apiId,
                                     name: name,
                                     category: pickerCategory(),
                                     brand: product.brand,
                                     imageUrlSmall: product.imageUrlSmall,
                                     imageUrlBig: product.imageUrlBig,
                                     isBought: false,
                                     amount: product.amount,
                                     unit: product.unit)

            do {context.insert(newProduct)
                try context.save()
            } catch {
                toastManager.show(type: .error)
                logger.error("Insertion error: \(error)")
            }

        } else {
            toastManager.show(type: .warning)
        }

        // Resetting values
        product = Product.MOCK_Product_empty
        name = ""
        displayedAmountUnit = ""
        displayedCategory = ""
        //Manual overwriting:
        product.apiId = ""
    }
    
    // format /////////////////////////
    func format(text: String) -> String {
        if text.count > 15 {
            let truncText = String(text.prefix(15))
            return truncText + "..."
        } else {
            return text
        }

    }
}

#Preview {
    let productApi = ProductApi(mock: false)
    let toastManager = ToastManager()
    return AddProductView(mockScan: true, productApi: productApi, toastManager: toastManager)
}
