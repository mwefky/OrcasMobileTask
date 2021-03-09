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
    
    var feedListvar = BehaviorRelay(value: [WeatherDTO()])
    var localFeedListvar = BehaviorRelay(value: [WeatherDTO()])
    var errorvar = BehaviorRelay(value: "")
    
    var feedList: Observable<([WeatherDTO?])> {
        return feedListvar.asObservable()
    }
    
    var localFeedList: Observable<([WeatherDTO?])> {
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
                feedListvar.accept(translateObjecteToDTO(weatherModel: weatherList))
                try? weatherManger.set(weather: weatherList)
                print("List of weather:", weatherList)
            }, onError: { error in
                if let localWeather = weatherManger.getWeather() {
                    localFeedListvar.accept(translateObjecteToDTO(weatherModel: localWeather))
                } else {
                    errorvar.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func translateObjecteToDTO(weatherModel: WeatherModel) -> [WeatherDTO?] {
        var localweather = [WeatherDTO()]
        localweather.removeAll()
        localweather.append(contentsOf: weatherModel.list.map { WeatherDTO(weatherDate: $0.dtTxt, weatherCondtion: $0.weather.first?.weatherDescription ?? "")})
        return localweather
    }
    
}
