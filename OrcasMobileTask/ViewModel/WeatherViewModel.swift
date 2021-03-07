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
    
    var feedListvar = BehaviorRelay(value: [WeatherModel]())
    var errorvar = BehaviorRelay(value: "")
    
    var feedList: Observable<([WeatherModel])> {
        return feedListvar.asObservable()
    }
    
    var error: Observable<String> {
        return errorvar.asObservable()
    }
    
    func fetchRemoteFeed(){
        
        APIManager.shared.getWeather(with: "Cairo") { (weather, error) in
            if error != nil {
                print(error)
            }else {
                print(weather)
            }
        }
    }
    
}
