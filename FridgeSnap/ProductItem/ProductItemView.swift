//
//  ShoppingListItemView.swift
//  FridgeSnap
//
//  Created by Franziska Link on 07.01.24.
//

import SwiftUI

struct ProductItemView: View {
    
    @State var product: Product
    
    @State var errorMessage = "Invalid amount"
    @FocusState var focusedField: InputType?
    @State var showingAmountSheet = false
    @State var brandIsAvailable = true
    
    
    init(product: Product) {
        self.product = product
    }
    var body: some View {
        HStack {
            // Photo of product //////////////////////////////////
            AsyncImage(url: URL(
                string: product.imageUrlSmall)) { phase in
                    switch phase {
                    case .empty:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: Padding.fotoSmall(),
                                   maxHeight: Padding.fotoSmall())
                            .foregroundColor(.gray)
                            .cornerRadius(Padding.small())
                            .opacity(product.isBought ? 0.5 : 1.0)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: Padding.fotoSmall(),
                                   maxHeight: Padding.fotoSmall())
                            .cornerRadius(Padding.small())
                            .opacity(product.isBought ? 0.5 : 1.0)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: Padding.fotoSmall(),
                                   maxHeight: Padding.fotoSmall())
                            .foregroundColor(.gray)
                            .cornerRadius(Padding.small())
                            .opacity(product.isBought ? 0.5 : 1.0)
                    @unknown default:
                        fatalError()
                    }
                }

            }

            Spacer(minLength: Padding.medium())
            
            // Name of product /////////////////////////////////////
            productNameBrand()
            Spacer(minLength: Padding.medium())
            
            // Amount of product////////////////////////////////////
            
            InputField(text: $product.displayedAmountUnit,
                       placeholder: "Amount",
                       isFocused: _focusedField,
                       fieldType: .amount)
            .font(.subheadline)
            .onChange(of: focusedField) { _ , _ in
                showingAmountSheet = true
            }
            .onChange(of: product.displayedAmountUnit) { _, newAmount in
                product.displayedAmountUnit = newAmount
            }
        
        .padding(Padding.small())
        .opacity(product.isBought ? 0.5 : 1.0)

        // Sheet for Picker ////////////////////////////////////
        .sheet(isPresented: $showingAmountSheet) {
            AmountUnitPickerView(pickerAmount: $product.amount, pickerUnit: $product.unit)
                .presentationDetents([.fraction(Padding.sheetFraction())])
                .onChange(of: product.amount){
                    product.displayedAmountUnit = "\(product.amount) \(product.unit.abbr())"
                }
        }
    }

    // format text //////////////////////////////////////////////////
    func format(text: String) -> String {
        if text.count > 7 {
            let truncText = String(text.prefix(7))
            return truncText + "..."
        } else {
            return text
        }
    }
    // generate View for product and brand  ///////////////////////////
    func productNameBrand() -> AnyView {
        if product.brand != "" {
            return VStack(alignment: .leading, spacing: Padding.small()) {
                Text(format(text: product.name))
                    .font(.subheadline)
                    .opacity(product.isBought ? 0.5 : 1.0)
                
                Text(format(text: product.brand))
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .opacity(product.isBought ? 0.5 : 1.0)

            } .eraseToAnyView()
            
        } else {
            return VStack(alignment: .leading, spacing: Padding.small()) {
                Text(format(text: product.name))
                    .font(.subheadline)
                    .opacity(product.isBought ? 0.5 : 1.0)

            }
            .eraseToAnyView()
        }
    }
}


#Preview {
    let sampleFoodItem = Product.MOCK_Product_full
    
    return ProductItemView(product: sampleFoodItem)
    
}

