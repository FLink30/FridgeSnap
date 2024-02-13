import Foundation
import os

class HttpApi {
    // Api Errors /////////////////////////////////////
    private enum ApiError: String, Error {
        case invalidUrl = "Invalid Url"
        case unexpectedStatusCode = "Unecpected Status Code"
        case connectionFailed  = "Connection Failed"
        case invalidJSON = "Invalid JSON"
        
        func callAsFunction() -> String {
            self.rawValue
        }
    }
    
    struct ProductResponse: Decodable {
        let code: String
        let product: ProductResponseDetails
        
        struct ProductResponseDetails: Decodable {
            let product_name: String
            let categories_hierarchy: [String]
            let brands: String?
            let image_front_small_url: String
            let image_url: String
        }
    }
    
    // Base URL of the API /////////////////////////////////////
    private static let openFoodFactsBaseURL = "https://world.openfoodfacts.org/api/v2/product"
    
    // generic get function /////////////////////////////////////
    static func get<T: Decodable>(url: String) async throws -> T {
        let logger: Logger = Logger()
        guard let parsedUrl = URL(string: url) else {
            logger.error("Error: \(ApiError.invalidUrl())")
            throw ApiError.invalidUrl
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: parsedUrl)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                logger.error("Error: \(ApiError.unexpectedStatusCode())")
                throw ApiError.unexpectedStatusCode
            }
            
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            logger.error("HttpApi Error: \(error)")
            throw error
        }
    }
    
    // generic get function /////////////////////////////////////
    static func getProduct(id: String) async throws -> ProductDetails? {
            let logger = Logger()
            do {
                let response = try await get(url: "\(openFoodFactsBaseURL)/\(id).json") as ProductResponse
                
                
                //look if categories matches to any of defined
                let categoriesArray = response.product.categories_hierarchy
                var category = Category.other
                
                if categoriesArray.contains("en:beverages") {
                    category = Category.beverage
                } else if categoriesArray.contains("en:cereals-and-potatoes") {
                    category = Category.cereals
                } else if categoriesArray.contains("en:dairies") {
                    category = Category.dairies
                } else if categoriesArray.contains("en:meats") {
                    category = Category.meat
                } else if categoriesArray.contains("en:fruits") {
                    category = Category.fruits
                } else if categoriesArray.contains("en:fresh-vegetables") {
                    category = Category.vegetables
                }
            
            return ProductDetails(
                apiId: response.code,
                name: response.product.product_name,
                categories: category,
                brand: response.product.brands ?? "",
                imageSmallUrl: response.product.image_front_small_url,
                imageUrl: response.product.image_url,
                amount: 1
            )
        } catch {
            logger.error("HttpApi Error: \(error)")
            return nil
        }
    }
}
