//
//  WeatherApi.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation
import Moya

enum WeatherApi {
    case fetchWeather(latitude: Double, longitude: Double, hourly: String)
    case test
}

extension WeatherApi: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.open-meteo.com")!
    }
    var path: String {
        switch self {
        case .fetchWeather:
            return "/v1/forecast"
        case .test:
            return "/v1/test"
        }
    }
    var method: Moya.Method {
        switch self {
        case .fetchWeather:
            return .get
        case .test:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .fetchWeather(let latitude, let longitude, let hourly):
            return .requestParameters(parameters: ["latitude": latitude, "longitude": longitude, "hourly": hourly], encoding: URLEncoding.default)
        case .test:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
