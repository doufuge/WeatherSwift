//
//  WeatherResponse.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation

struct WeatherResponse: Decodable {
    let latitude: Double
    let longitude: Double
    let generationtime_ms: Double
    let utc_offset_seconds: Int
    let timezone: String
    let timezone_abbreviation: String
    let elevation: Double
    let hourly_units: HourlyUnits
    let hourly: Hourly
}

struct HourlyUnits: Decodable {
    let time: String
    let temperature_2m: String
}

struct Hourly: Decodable {
    let time: [String]
    let temperature_2m: [Double]
}
