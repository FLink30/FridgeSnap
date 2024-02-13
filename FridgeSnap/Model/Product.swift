//
//  ProductModel.swift
//  Pokedeck
//
//  Created by Daniel on 12.12.23.
//

import Foundation
import SwiftData

@Model
class Product: Identifiable {
    var id: UUID = UUID()
    var apiId: String
    var name: String
    // SwiftData funktioiert leider mit Enum als property nicht
    var category: String
    var brand: String
    var imageUrlSmall: String
    var imageUrlBig: String
    var isBought: Bool
    var amount: Int
    var displayedAmountUnit: String
    var unit: Unit
    
    init(apiId: String, name: String, category: String, brand: String, imageUrlSmall: String, imageUrlBig: String, isBought: Bool, amount: Int, unit: Unit) {
        self.apiId = apiId
        self.name = name
        self.category = category
        self.brand = brand
        self.imageUrlSmall = imageUrlSmall
        self.imageUrlBig = imageUrlBig
        self.isBought = isBought
        self.amount = amount
        self.displayedAmountUnit = "\(amount) \(unit.abbr())"
        self.unit = unit
    }
}

// MOCK Products /////////////////////////////////////
extension Product {
    static var MOCK_Product_full = Product(apiId: "", name: "Cheese", category: Category.dairies(), brand: "Milbona", imageUrlSmall: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.200.jpg",  imageUrlBig: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.200.jpg", isBought: false, amount: 1, unit: .count)
    static var MOCK_Product_empty = Product(apiId: "", name: "", category: Category.other(), brand: "", imageUrlSmall: "",  imageUrlBig: "", isBought: false, amount: 1, unit: .count)
}
