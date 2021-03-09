//
//  OrcasMobileTaskTests.swift
//  OrcasMobileTaskTests
//
//  Created by mina wefky on 07/03/2021.
//

import XCTest
import RxSwift
@testable import OrcasMobileTask

class OrcasMobileTaskTests: XCTestCase {
    var mockNetwork: ApiClient!
    var mockCached: WeatherManager!
    let disposeBag = DisposeBag()
    override func setUpWithError() throws {
        //        mockNetwork = ApiClient.shared
    }
    
    override func tearDownWithError() throws {
        mockNetwork = nil
        super.tearDown()
    }
    
    func testValidateNetWorkCallsForVenue() {
        
        let promise = expectation(description: "Status code: 200")
        ApiClient.getWeather(cityName: "Cairo")
            .subscribe(onNext: { _ in
                promise.fulfill()
            }, onError: { (error) in
                XCTFail("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        wait(for: [promise], timeout: 5)
    }
    
    func testCallToWeatherMapCompletes() {
        ApiClient.getWeather(cityName: "Cairo")
            .subscribe(onNext: { weatherList in
                    self.mockCached = WeatherManager(cacheKey: "Cairo")
                    let cachedMocked = self.mockCached.getWeather()
                    XCTAssertEqual(cachedMocked, weatherList)
            }, onError: { (error) in
                XCTFail("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
