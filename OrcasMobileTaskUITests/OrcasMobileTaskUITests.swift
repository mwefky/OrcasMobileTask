//
//  OrcasMobileTaskUITests.swift
//  OrcasMobileTaskUITests
//
//  Created by mina wefky on 07/03/2021.
//

import XCTest
@testable import OrcasMobileTask
class OrcasMobileTaskUITests: XCTestCase {

    var mockviewController: WeatherViewController!

    override func setUpWithError() throws {
        continueAfterFailure = false
        let bundle = Bundle(for: type(of: self))
        let storyBoard = UIStoryboard(name: "Main", bundle: bundle)
        self.mockviewController =  storyBoard.instantiateInitialViewController() as? WeatherViewController
        self.mockviewController.loadView()
        self.mockviewController.viewDidLoad()
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
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
