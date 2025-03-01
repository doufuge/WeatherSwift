//
//  WeatherViewModel.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let fetchWeather: FetchWeatherUseCase
    
    private var cancellables = Set<AnyCancellable>()

    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    
//    @Published var data: [WeatherItem] = []
//    @Published var showTable: Bool = false
    
    var state: State = State()
    
//    var tipOptions: TipOptions = TipOptions(show: false, tip: "")
    
    init(fetchWeather: FetchWeatherUseCase) {
        self.fetchWeather = fetchWeather
        locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func loadWeather() {
        if (currentLocation != nil && currentLocation?.coordinate != nil) {
            cancellables.forEach {
                $0.cancel()
            }
            fetchWeather.execute(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
                .sink { [weak self] result in
                    switch result {
                    case .loading:
                        self?.state.loading = true
                        print("======= loading")
                    case .success(let weatherItems):
                        print("======= success")
                        self?.state.loading = false
                        self?.state.data = weatherItems
                        self?.state.uiEvent = .showTip(message: "Fetch weather success!", autoHide: true)
                    case .failure(let error):
                        self?.state.loading = false
                        self?.state.uiEvent = .showTip(message: "Fetch weather data error: \(error.localizedDescription)!", autoHide: true)
                        print("======= failure: \(error.localizedDescription)")
                    }
                }
                .store(in: &cancellables)
        } else {
            self.state.uiEvent = .showTip(message: "Has no available location", autoHide: true)
        }
    }
    
    func toggleViewMode() {
        state.showTable.toggle()
    }
    
    func showTip(show: Bool, tip: String, autoHide: Bool) {
        state.uiEvent = .showTip(message: tip, autoHide: autoHide)
//        self.tipOptions = TipOptions(show: show, tip: tip, autoHide: autoHide)
    }
    
//    func onTipShow() {
//        if tipOptions.show && tipOptions.autoHide {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.tipOptions = TipOptions(show: false, tip: "")
//            }
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.currentLocation = newLocation
            self.loadWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        state.uiEvent = .showTip(message: "Get location error: \(error.localizedDescription)", autoHide: false)
    }
    
}

class State: ObservableObject {
    @Published var showTable: Bool = false
    @Published var loading: Bool = true
    @Published var uiEvent: WeatherUiEvent? = nil
    @Published var tip: String = ""
    @Published var data: [WeatherItem] = []
}

enum WeatherUiEvent {
    case reload
    case showTip(message: String, autoHide: Bool = false)
}
