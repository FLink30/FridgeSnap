import SwiftUI
import SwiftData
import os

struct ProductListView: View {
    
    //Logger
    let logger: Logger = Logger()
    
    //Swift Data
    @Environment(\.modelContext) private var context
    @State var productApi: ProductApi
    @Query var productList: [Product]
    @State private var expandedSections: Set<AnyHashable> = []
    
    // Toast and Error ////////////////////////
    @ObservedObject var toastManager = ToastManager()
    
    var body: some View {
        NavigationView {
            VStack {
                if productList.isEmpty {
                    Spacer()
                    Text("Empty List")
                } else {
                    List {
                        let sortedCategories = productList.reduce(into: [:]) { result, product in
                            result[product.category(), default: []].append(product)
                        }.sorted { $0.key < $1.key }

                        ForEach(sortedCategories, id: \.key) { category, products in
                            DisclosureGroup(
                                isExpanded: Binding(
                                    get: { self.isExpanded(category) },
                                    set: { self.setExpanded(category, expanded: $0) }
                                ),
                                content: {
                                    let sortedProducts = products.sorted { $0.name < $1.name }
                                    ForEach(sortedProducts) { product in
                                        HStack {
                                            Image(systemName: product.isBought ? "checkmark.circle" : "circle")
                                                .opacity(product.isBought ? Padding.opacityMedium() : Padding.opacityNull())
                                                .onTapGesture {
                                                    if let index = productList.firstIndex(of: product) {
                                                        productList[index].isBought.toggle()
                                                    }
                                                }

                                            NavigationLink(destination: ProductDetailView(product: product)) {
                                                ProductItemView(product: product)
                                            }
                                        }
                                    }.onDelete { indexSet in
                                        for index in indexSet {
                                            do {
                                                context.delete(sortedProducts[index])
                                                try context.save()
                                            } catch {
                                                logger.error("Product deletion error: \(error)")

                                            }
                                        }
                                        toastManager.show(type: .delete)

                                    }
                                },
                                label: {
                                    Text(category)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                }
                            )
                        }
                    }
                }
                Spacer()

                AddProductView(mockScan: false, productApi: productApi, toastManager: toastManager)
            }
            .navigationTitle("Shopping List:")
            .overlay(
                ToastView(type: toastManager.toastType, title: toastManager.toastTitle, message: toastManager.toastMessage)
                    .padding(.top, 264)
                    .opacity(toastManager.toastVisible ? 1 : 0)
                    )             
            .navigationBarItems(trailing:
                Button(action: {
                    do {
                        try context.delete(model: Product.self)
                        toastManager.show(type: .deleteList)
                        try context.save()
                    } catch {
                        logger.error("List deletion error: \(error)")
                    }
                }) {
                    Image(systemName: "trash")
                }
            )
        }
    }

    private func isExpanded(_ category: AnyHashable) -> Bool {
        return expandedSections.contains(category)
    }

    private func setExpanded(_ category: AnyHashable, expanded: Bool) {
        if expanded {
            expandedSections.insert(category)
        } else {
            expandedSections.remove(category)
        }
    }
}


#Preview{
    ProductListView(productApi: ProductApi(mock: true))
}
