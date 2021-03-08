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
    var localFeedListvar = BehaviorRelay(value: WeatherModel())
    var errorvar = BehaviorRelay(value: "")
    
    var feedList: Observable<(WeatherModel?)> {
        return feedListvar.asObservable()
    }
    
    var localFeedList: Observable<(WeatherModel?)> {
        return localFeedListvar.asObservable()
    }
    var error: Observable<String> {
        return errorvar.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    func fetchRemoteFeed(with cityName: String) {
        let weatherManger = WeatherManager(cacheKey: cityName)
        
        ApiClient.getWeather(cityName: cityName).observeOn(MainScheduler.instance)
            .subscribe(onNext: { weatherList in
                feedListvar.accept(weatherList)
                try? weatherManger.set(weather: weatherList)
                print("List of weather:", weatherList)
            }, onError: { error in
                if let localWeather = weatherManger.getWeather() {
                    localFeedListvar.accept(localWeather)
                } else {
                    errorvar.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
