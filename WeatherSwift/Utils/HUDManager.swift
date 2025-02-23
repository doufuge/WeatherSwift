//
//  HUDManager.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/23.
//

import Combine

class HUDManager {
    
    static let shared = HUDManager()
    
    private let _isLoading = CurrentValueSubject<Bool, Never>(false)
    
    var isLoading: AnyPublisher<Bool, Never> {
        return _isLoading.eraseToAnyPublisher()
    }
    
    func show() {
        _isLoading.send(true)
    }
    
    func hide() {
        _isLoading.send(false)
    }
    
}
