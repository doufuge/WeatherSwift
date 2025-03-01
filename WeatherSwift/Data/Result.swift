//
//  Result.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/3/1.
//

import Combine

enum Result<T> {
    case loading
    case success(T)
    case failure(Error)
}
