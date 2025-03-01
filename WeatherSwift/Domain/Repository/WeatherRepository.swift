//
//  WeatherRepository.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/3/1.
//

import Foundation
import Combine

protocol WeatherRepository {
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String) -> AnyPublisher<[WeatherItem], Error>
    
}

extension WeatherRepository {
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<[WeatherItem], Error> {
        return fetchWeather(latitude: latitude, longitude: longitude, hourly: "temperature_2m")
    }
    
}
