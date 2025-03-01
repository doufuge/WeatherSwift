//
//  WeatherRepositoryImpl.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/3/1.
//

import Foundation
import Combine
import CombineMoya

class WeatherRepositoryImpl: WeatherRepository {
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String = "temperature_2m") -> AnyPublisher<[WeatherItem], any Error> {
        return weatherProvider
            .requestPublisher(.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly))
            .filter { $0.statusCode == 200 }
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { data in
                data.hourly.time.enumerated().map({ (index, item) in
                    return WeatherItem(hour: item, temp: data.hourly.temperature_2m[index])
                })
            }
            .eraseToAnyPublisher()
    }
    
}
