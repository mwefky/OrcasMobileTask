//
//  APIManager.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import Foundation


class APIManager {
    
    static let shared = APIManager()
    
    let baseURL = "https://api.openweathermap.org/data/2.5/forecast?"
    let APIKEY =  "eeaa2ec22ee3bc9f60c63de7cd76b879"
    
    func getWeather(with cityName: String,completed: @escaping (WeatherModel?, Error?)->()){
        
        Network.shared.fetchCodableObject(method: .get, url: "\(baseURL)q=\(cityName)&appid=\(APIKEY)", parameters: nil) { (result, error) in
                        if error != nil {
                completed(nil,error)
            }
            
            do {
                guard let json = result else {return}
                let waathers = try JSONDecoder().decode(WeatherModel.self, from: json)
                completed(waathers, nil)
            } catch let error {
                print("Error creating object from JSON: \(error.localizedDescription)")
                completed(nil,error)
            }

        }    }
    
    

}
