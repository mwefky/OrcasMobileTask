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
    
    func fetchRemoteFeed(with cityName: String){
        
        APIManager.shared.getWeather(with: cityName) { (weather, error) in
            if error != nil {
                print(error)
            }else {
                guard let feed = weather else {return}
                feedListvar.accept(feed)
            }
        }
    }
    
}
