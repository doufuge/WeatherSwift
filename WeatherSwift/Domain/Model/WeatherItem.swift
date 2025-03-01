//
//  WeatherItem.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation

struct WeatherItem: Identifiable {
    let hour: String
    let temp: Double
    let tempUnit: String = "°C"
    let id: UUID = UUID()
}
