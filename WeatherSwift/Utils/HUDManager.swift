//
//  HUDManager.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/23.
//

import RxSwift

class HUDManager {
    
    static let shared = HUDManager()
    
    private let _isLoading = BehaviorSubject<Bool>(value: false)
    
    var isLoading: Observable<Bool> {
        return _isLoading.asObservable()
    }
    
    func show() {
        _isLoading.onNext(true)
    }
    
    func hide() {
        _isLoading.onNext(false)
    }
    
}
