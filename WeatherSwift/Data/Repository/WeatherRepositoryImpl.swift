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
    
//    func fetchWeather(latitude: Double, longitude: Double, hourly: String = "temperature_2m") -> AnyPublisher<Result<[WeatherItem]>, Never> {
//        return weatherProvider
//            .requestPublisher(.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly))
//            .filter { $0.statusCode == 200 }
//            .map { $0.data }
//            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
//            .map { data in
//                data.hourly.time.enumerated().map({ (index, item) in
//                    return WeatherItem(hour: item, temp: data.hourly.temperature_2m[index])
//                })
//            }
//            .eraseToAnyPublisher()
//    }
    
    func fetchWeather(latitude: Double, longitude: Double, hourly: String = "temperature_2m") -> AnyPublisher<Result<[WeatherItem]>, Never> {
        return Just(Result.loading)
            .append(
                weatherProvider
                    .requestPublisher(.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly))
                    .filter { $0.statusCode == 200}
                    .map(\.data)
                    .decode(type: WeatherResponse.self, decoder: JSONDecoder())
                    .map { data in
                        data.hourly.time.enumerated().map({ (index, item) in
                            return WeatherItem(hour: item, temp: data.hourly.temperature_2m[index])
                        })
                    }
                    .map { data in
                        Result.success(data)
                    }
                    .catch { error in
                        Just(Result.failure(error))
                    }
            )
            .eraseToAnyPublisher()
        
//        return Deferred {
//            Future { promise in
//                promise(.success(.loading))
//                DispatchQueue.global(qos: .background).async {
//                    do {
//                        weatherProvider
//                            .requestPublisher(.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly))
//                            .filter { $0.statusCode == 200}
//                            .map(\.data)
//                            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
//                            .map { data in
//                                data.hourly.time.enumerated().map({ (index, item) in
//                                    return WeatherItem(hour: item, temp: data.hourly.temperature_2m[index])
//                                })
//                            }
//                        
//                        let weatherList = try self.weatherApi.fetchWeather(latitude: latitude, longitude: longitude, hourly: hourly).toWeatherList()
//                                                promise(.success(.success(weatherList)))
//                    } catch {
//                        promise(.success(.failure(error)))
//                    }
//                }
//                
//            }
//        }
//        .receive(on: DispatchQueue.main)
//        .eraseToAnyPublisher()
        
    }
    
}
