//
//  WeatherApi.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation
import Moya

let weatherProvider = MoyaProvider<WeatherApi>(
    endpointClosure: customEndpointClosure,
    stubClosure: customStubClosure,
    session: AppModule.sharedInstance.session(),
    plugins: [NetworkLoggerPlugin(), AppModule.sharedInstance.hudPlugin]
)

let customEndpointClosure = { (target: WeatherApi) -> Endpoint in
    switch target {
    case .test2:
        return Endpoint(
            url: target.baseURL.appendingPathComponent("/v1/test2").absoluteString,
            sampleResponseClosure: {
                .networkResponse(404, target.sampleData)
            },
            method: .get,
            task: .requestPlain,
            httpHeaderFields: [:]
        )
    default:
        var endpoint = MoyaProvider.defaultEndpointMapping(for: target)
        let headers = AppModule.sharedInstance.sessionHeader(target.path)
        print(headers)
        return endpoint.adding(newHTTPHeaderFields: headers)
    }
}

let customStubClosure: (_ type: WeatherApi) -> Moya.StubBehavior  = { target in
    switch target {
    case .fetchWeather:
        return Moya.StubBehavior.never
    case .test:
        return Moya.StubBehavior.immediate
    default:
        return Moya.StubBehavior.delayed(seconds: 3)
    }
}

enum WeatherApi {
    case fetchWeather(latitude: Double, longitude: Double, hourly: String)
    case test
    case test2
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
        case .test2:
            return "/v1/test2"
        }
    }
    var method: Moya.Method {
        switch self {
        case .fetchWeather:
            return .get
        case .test:
            return .post
        default:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .fetchWeather(let latitude, let longitude, let hourly):
            return .requestParameters(parameters: ["latitude": latitude, "longitude": longitude, "hourly": hourly], encoding: URLEncoding.default)
        case .test:
            return .requestPlain
        default:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
