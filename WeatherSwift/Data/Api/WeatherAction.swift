//
//  NetworkService.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation
import Moya
import CombineMoya
import Combine

class WeatherAction {
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String = "temperature_2m") -> AnyPublisher<[WeatherItem], Error> {
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
