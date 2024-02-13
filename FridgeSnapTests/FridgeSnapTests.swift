//
//  FridgeSnapTests.swift
//  FridgeSnapTests
//
//  Created by Daniel on 12.12.23.
//

import XCTest
@testable import FridgeSnap

final class FridgeSnapTests: XCTestCase {

  /*  override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
*/
    func testgetProductDetails() async throws {
        do{
            let api = ProductApi(mock: false)
            if let product = try await api.getProductDetails(id: "8000500269169"){
                XCTAssertTrue(product.name == "Kinder - Cards 10 Biscuits, 128g (4.6oz)", "Unexpected: product name is \(product.name)")
            }
        }catch{
            XCTFail("Threw an error")
        }
    }
    
    func testFailedgetProductDetails() async throws {
        do{
            let api = ProductApi(mock: false)
            if let product = try await api.getProductDetails(id: "Test"){
                XCTFail("Unexpected: product is \(product)")
            }
            else{
                XCTAssert(true)
            }
        }catch{
            XCTAssert(true)
        }
    }
    
    func testformats(){
        let view = ProductItemView(product: Product(apiId: "", name: "", category: "", brand: "", imageUrlSmall: "",  imageUrlBig: "", isBought: false, amount: 0, unit: .count))
        let long = view.format(text: "Testschokoladenbehälteranmalmaschine")
        let short = view.format(text: "Schoko")
        XCTAssertTrue(long.hasSuffix("..."), "Unexpected: String doesn't end with ... : \(long)")
        XCTAssertFalse(short.hasSuffix("..."), "Unexpected: String ends with ... : \(short)")
        
    }

    func testPerformanceApi() throws {
        // This is an example of a performance test case.
        self.measure {
            Task{
                let api = ProductApi(mock: false)
                do{
                    _ = try await api.getProductDetails(id: "8000500269169")
                }catch{
                    XCTFail()
                }
            }
            self.stopMeasuring()
            
        }
    }

}
