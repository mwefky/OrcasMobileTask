//
//  WeatherModel.swift
//  OrcasMobileTask
//
//  Created by mina wefky on 07/03/2021.
//

import Foundation
import CodableCache

// MARK: - WeatherModel
struct WeatherModel: Codable, Equatable {
   
    let cod: String
    let message: Double
    let cnt: Int
    let list: [List]
    let city: City
    
    init?() {
        return nil
    }
    
    static func == (lhs: WeatherModel, rhs: WeatherModel) -> Bool {
        return true
    }
}

// MARK: - City
struct City: Codable {
    let name: String
    let coord: Coord
    let country: String
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct List: Codable {
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let sys: Sys
    let dtTxt: String
    let rain, snow: Rain?

    enum CodingKeys: String, CodingKey {
        case main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax, pressure: Double
    let seaLevel, grndLevel: Double
    let humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct Weather: Codable {
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Double
}

// MARK: - caching
final class WeatherManager {

    let cache: CodableCache<WeatherModel>

    init(cacheKey: AnyHashable) {
        cache = CodableCache<WeatherModel>(key: cacheKey)
    }

    func getWeather() -> WeatherModel? {
        return cache.get()
    }

    func set(weather: WeatherModel) throws {
        try? cache.set(value: weather)
    }
}
