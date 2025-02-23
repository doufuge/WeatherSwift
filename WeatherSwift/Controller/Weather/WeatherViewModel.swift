//
//  WeatherViewModel.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject, CLLocationManagerDelegate {
    
    private let weatherAction = WeatherAction()
    private var locationManager: CLLocationManager
    private var currentLocation: CLLocation?
    
    var showTable: Bool = false {
        didSet {
            onViewModeChanged?()
        }
    }
    var data: [WeatherItem] = [] {
        didSet {
            onWeatherDataLoaded?()
        }
    }
    var loading: Bool = true {
        didSet {
            onLoadStatusChanged?()
        }
    }
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
            loading = true
            weatherAction.fetchWeather(latitude: (currentLocation?.coordinate.latitude)!, longitude: (currentLocation?.coordinate.longitude)!) { result in
                switch result {
                case .success(let json):
                    if json.hourly.time.count == json.hourly.temperature_2m.count {
                        self.data = json.hourly.time.enumerated().map({ (index, item) in
                            return WeatherItem(hour: item, temp: json.hourly.temperature_2m[index])
                        })
                    }
                    self.showTip(show: true, tip: "Fetch Success", autoHide: true)
                    self.loading = false
                case .failure(let error):
                    self.showTip(show: true, tip: "Fetch error: \(error.localizedDescription)", autoHide: true)
                    self.loading = false
                }
            }
        } else {
            self.showTip(show: true, tip: "Has no available location", autoHide: true)
        }
    }
    
    var onWeatherDataLoaded: (() -> Void)?
    var onLoadStatusChanged: (() -> Void)?
    var onViewModeChanged: (() -> Void)?
    
    func toggleViewMode() {
        showTable.toggle()
    }
    
    func showTip(show: Bool, tip: String, autoHide: Bool) {
//        withAnimation(.easeInOut(duration: 0.5)) {
            self.tipOptions = TipOptions(show: show, tip: tip, autoHide: autoHide)
//        }
    }
    
    func onTipShow() {
        if tipOptions.show && tipOptions.autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                withAnimation(.easeInOut(duration: 0.5)) {
                    self.tipOptions = TipOptions(show: false, tip: "")
//                }
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
