//
//  FridgeSnapUITests.swift
//  FridgeSnapUITests
//
//  Created by Daniel on 12.12.23.
//

import XCTest

final class FridgeSnapUITests: XCTestCase {

//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }

//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func testAddingItem(){
        let app = XCUIApplication()
        app.launch()
        XCUIApplication().navigationBars["Shopping List:"]/*@START_MENU_TOKEN@*/.buttons["Bin"]/*[[".otherElements[\"Bin\"].buttons[\"Bin\"]",".buttons[\"Bin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields["Product name"].tap()
        app.textFields["Product name"].typeText("Testschokolade")
        app.textFields["Amount"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["1 time"]/*[[".pickers[\"Picker\"].pickerWheels[\"1 time\"]",".pickerWheels[\"1 time\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        app.staticTexts["Done"].tap()
        app.buttons["Arrow Up Circle"].tap()
        
        let sidebarCollectionView = app.collectionViews["Sidebar"]
        sidebarCollectionView/*@START_MENU_TOKEN@*/.buttons.containing(.image, identifier:"collapsed").element/*[[".cells.buttons.containing(.image, identifier:\"collapsed\").element",".buttons.containing(.image, identifier:\"collapsed\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sidebarCollectionView/*@START_MENU_TOKEN@*/.buttons["Testscho..."]/*[[".cells.buttons[\"Testscho...\"]",".buttons[\"Testscho...\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.staticTexts["Testschokolade"].exists, "Doesn't show Testshokolade")
    }
    
    func testDeleting(){
        let app = XCUIApplication()
        app.launch()
        app.textFields["Product name"].tap()
        app.textFields["Product name"].typeText("Das muss weg")
        app.buttons["Arrow Up Circle"].tap()
        XCUIApplication().navigationBars["Shopping List:"]/*@START_MENU_TOKEN@*/.buttons["Bin"]/*[[".otherElements[\"Bin\"].buttons[\"Bin\"]",".buttons[\"Bin\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.staticTexts["Empty List"].exists, "List isn't empty")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
