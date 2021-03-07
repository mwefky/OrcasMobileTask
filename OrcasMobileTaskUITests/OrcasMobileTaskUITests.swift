//
//  OrcasMobileTaskUITests.swift
//  OrcasMobileTaskUITests
//
//  Created by mina wefky on 07/03/2021.
//

import XCTest
@testable import OrcasMobileTask
class OrcasMobileTaskUITests: XCTestCase {

    var mockviewController: ViewController!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mockviewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }

    override func tearDownWithError() throws {
        self.mockviewController.loadView()
        self.mockviewController.viewDidLoad()
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
    func testHasATableView() {
        XCTAssertNotNil(mockviewController.tableView)
    }
    
    func testTableViewHasDelegate() {
        XCTAssertNotNil(mockviewController.tableView.delegate)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol() {
           XCTAssertTrue(mockviewController.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(mockviewController.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(mockviewController.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(mockviewController.responds(to: #selector(mockviewController.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(mockviewController.responds(to: #selector(mockviewController.tableView(_:cellForRowAt:))))
    }
    
    func testTableViewCellHasReuseIdentifier() {
           let cell = mockviewController.tableView(mockviewController.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? DailyWeatherTableViewCell
           let actualReuseIdentifer = cell?.reuseIdentifier
           let expectedReuseIdentifier = "DailyWeatherTableViewCell"
           XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
