//
//  NetworkService.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation
import Moya

class WeatherAction {
    
    private let provider = MoyaProvider<WeatherApi>()
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String = "temperature_2m", completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        provider.request(.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly)) { result in
            switch result {
            case .success(let response):
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: response.data)
                    completion(.success(weatherResponse))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
