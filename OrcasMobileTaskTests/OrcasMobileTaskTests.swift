//
//  OrcasMobileTaskTests.swift
//  OrcasMobileTaskTests
//
//  Created by mina wefky on 07/03/2021.
//

import XCTest
@testable import OrcasMobileTask

class OrcasMobileTaskTests: XCTestCase {
    var mockNetwork: Network!
    var mockCached: WeatherManager!
    override func setUpWithError() throws {
        mockNetwork = Network.shared
    }

    override func tearDownWithError() throws {
        mockNetwork = nil
        super.tearDown()
    }

    func testValidateNetWorkCallsForVenue() {
        
        let url = "https://api.openweathermap.org/data/2.5/forecast?q=Cairo&appid=eeaa2ec22ee3bc9f60c63de7cd76b879"
        
        let promise = expectation(description: "Status code: 200")
        mockNetwork.fetchCodableObject(method: .get, url: url, parameters: nil) { (response, error) in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if response != nil {
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
    func testCallToWeatherMapCompletes() {
        let url = "https://api.openweathermap.org/data/2.5/forecast?q=Cairo&appid=eeaa2ec22ee3bc9f60c63de7cd76b879"
        let promise = expectation(description: "Completion handler invoked")
        var responseError: Error?
        var responseModel: WeatherModel?
        mockNetwork.fetchCodableObject(method: .get, url: url, parameters: nil) { (response, error) in
            responseError = error
            responseModel = try? JSONDecoder().decode(WeatherModel.self, from: response!)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        XCTAssertNil(responseError)
        mockCached = WeatherManager(cacheKey: "Cairo")
        let cachedMocked = mockCached.getWeather()
    
        XCTAssertEqual(cachedMocked, responseModel)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
