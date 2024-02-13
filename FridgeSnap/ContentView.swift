//
//  ContentView.swift
//  FridgeSnap
//
//  Created by Daniel on 12.12.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var api: ProductApi

    init(api: ProductApi){
        self.api = api
    }

    var body: some View {
        ProductListView(productApi: api)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Product.self, configurations: config)
    let product = Product(apiId: "", name: "Cheese", category: Category.other(), brand: "Milbona", imageUrlSmall: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.200.jpg",  imageUrlBig: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.200.jpg", isBought: false, amount: 1, unit: .count)
    container.mainContext.insert(product)
    
    return ContentView(api: ProductApi(mock: false))
        .modelContainer(container)
}

