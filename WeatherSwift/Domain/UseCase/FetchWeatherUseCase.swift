//
//  FetchWeatherUseCase.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/3/1.
//

import Foundation
import Combine

class FetchWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(latitude: Double, longitude: Double) ->  AnyPublisher<Result<[WeatherItem]>, Never> {
        return repository.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
    
}

