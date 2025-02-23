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
    
    private var cancellables = Set<AnyCancellable>()
    
    private let weatherAction = WeatherAction()
    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    
    @Published var data: [WeatherItem] = []
    @Published var showTable: Bool = false
    
    var tipOptions: TipOptions = TipOptions(show: false, tip: "")
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func fetchWeather() {
        if (currentLocation != nil && currentLocation?.coordinate != nil) {
            cancellables.forEach {
                $0.cancel()
            }
            weatherAction.fetchWeather(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("======= finish")
                    case .failure(let error):
                        print("======= failure: \(error.localizedDescription)")
                    }
                }, receiveValue: { [weak self] WeatherItems in
                    self?.data = WeatherItems
                })
                .store(in: &cancellables)
            
        } else {
            self.showTip(show: true, tip: "Has no available location", autoHide: true)
        }
    }
    
    func toggleViewMode() {
        showTable.toggle()
    }
    
    func showTip(show: Bool, tip: String, autoHide: Bool) {
        self.tipOptions = TipOptions(show: show, tip: tip, autoHide: autoHide)
    }
    
    func onTipShow() {
        if tipOptions.show && tipOptions.autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.tipOptions = TipOptions(show: false, tip: "")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            self.currentLocation = newLocation
            self.fetchWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        self.showTip(show: true, tip: "Get location error: \(error.localizedDescription)", autoHide: false)
    }
    
}
