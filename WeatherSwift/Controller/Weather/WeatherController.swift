//
//  WeatherController.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import UIKit
import Combine

class WeatherController: UIViewController {
    
    var viewModel = WeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var hud: Hud!
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var tableChart: TableChart!
    @IBOutlet weak var viewModeBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        viewModel.startUpdatingLocation()
    
        HUDManager.shared.isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                self?.hud.isHidden = !isLoading
            })
            .store(in: &cancellables)
        viewModel.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherItems in
                self?.lineChart.data = (self?.viewModel.data)!
                self?.tableChart.data = (self?.viewModel.data)!
            }
            .store(in: &cancellables)
        viewModel.$showTable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showTable in
                if showTable == true {
                    self?.tableChart.isHidden = false
                    self?.lineChart.isHidden = true
                    self?.viewModeBtn.image = UIImage(systemName: "chart.xyaxis.line")
                } else {
                    self?.tableChart.isHidden = true
                    self?.lineChart.isHidden = false
                    self?.viewModeBtn.image = UIImage(systemName: "list.bullet")
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func reload(_ sender: Any) {
        viewModel.fetchWeather()
    }
    
    @IBAction func toggleViewMode(_ sender: Any) {
        viewModel.toggleViewMode()
    }

}
