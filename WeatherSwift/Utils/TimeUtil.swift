//
//  TimeUtil.swift
//  WeatherSwiftUI
//
//  Created by Johny Fu on 2025/2/21.
//

import Foundation

class TimeUtil {
    
    static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()
    
    static let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()
    
    static let outputHourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    static func format(_ timeStr: String) -> String {
        if let date = inputFormatter.date(from: timeStr) {
            return outputFormatter.string(from: date)
        }
        return ""
    }
    
    static func formatHour(_ timeStr: String) -> String {
        if let date = inputFormatter.date(from: timeStr) {
            return outputHourFormatter.string(from: date)
        }
        return ""
    }
    
}
