//
//  WeatherViewModel.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//
import Foundation
import RxSwift
import RxRelay

struct WeatherViewModel {
    
    var feedListvar = BehaviorRelay(value: WeatherModel())
    var errorvar = BehaviorRelay(value: "")
    
    var feedList: Observable<(WeatherModel?)> {
        return feedListvar.asObservable()
    }
    
    var error: Observable<String> {
        return errorvar.asObservable()
    }
    
    func fetchRemoteFeed(with cityName: String) {
        
        let weatherManger = WeatherManager(cacheKey: cityName)
        APIManager.shared.getWeather(with: cityName) { (weather, error) in
            if error != nil {
                // MARK: - get cache
                if let cachedWeather = weatherManger.getWeather() {
                    feedListvar.accept(cachedWeather)
                    errorvar.accept("not accurate data")
                } else {
                    errorvar.accept("not data")
                }
            } else {
                guard let feed = weather else {return}
                // MARK: - set cache
                try? weatherManger.set(weather: feed)
                feedListvar.accept(feed)
            }
        }
    }
    
}
