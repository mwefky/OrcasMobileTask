//
//  APIManager.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import Foundation
import RxSwift
import Alamofire

class ApiClient {
    
    static func getWeather(cityName: String) -> Observable<WeatherModel> {
        return request(ApiRouter.getWeather(cityName: cityName))
    }
    
    // MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = AF.request(urlConvertible).responseDecodable {  (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                        observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

struct NetworkConstants {
    static let BASEURL = "https://api.openweathermap.org"
    static let APIKEY = "eeaa2ec22ee3bc9f60c63de7cd76b879"
}
