import Foundation
import os

class ProductApi {
    let logger: Logger = Logger()
    let mock: Bool
    
    init(mock: Bool = false) {
        self.mock = mock
    }
    
    func getProductDetails(id: String) async throws -> ProductDetails? {
        if mock {
            return ProductDetails.MOCK_ProductDetail_full
        } else {
            do {
                return try await HttpApi.getProduct(id: id)
            } catch {
                logger.error("Error \(error) was thrown")
                throw error
            }
        }
    }
}

struct ProductDetails {
    let apiId: String
    let name: String
    let categories: Category
    var brand: String
    let imageSmallUrl: String
    let imageUrl: String
    var amount: Int
}

extension ProductDetails {
    static var MOCK_ProductDetail_full = ProductDetails(apiId: "20011581",
                                                    name: "Gouda",
                                                    categories: Category.dairies,
                                                    brand: "Milbona",
                                                    imageSmallUrl: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.200.jpg",
                                                    imageUrl: "https://images.openfoodfacts.org/images/products/20011581/front_en.54.400.jpg",
                                                    amount: 1)
}
