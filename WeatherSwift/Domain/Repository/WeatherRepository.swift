//
//  WeatherRepository.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/3/1.
//

import Foundation
import Combine

protocol WeatherRepository {
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String) -> AnyPublisher<Result<[WeatherItem]>, Never>
    
}

extension WeatherRepository {
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<Result<[WeatherItem]>, Never> {
        return fetchWeather(latitude: latitude, longitude: longitude, hourly: "temperature_2m")
    }
    
}
