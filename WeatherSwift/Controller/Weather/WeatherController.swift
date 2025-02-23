//
//  WeatherController.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import UIKit
import RxSwift

class WeatherController: UIViewController {
    
    var viewModel = WeatherViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var hud: Hud!
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var tableChart: TableChart!
    @IBOutlet weak var viewModeBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        viewModel.startUpdatingLocation()
        viewModel.onWeatherDataLoaded = { [weak self] in
            self?.lineChart.data = (self?.viewModel.data)!
            self?.tableChart.data = (self?.viewModel.data)!
        }
        HUDManager.shared.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.hud.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
        viewModel.onViewModeChanged = { [weak self] in
            if self?.viewModel.showTable == true {
                self?.tableChart.isHidden = false
                self?.lineChart.isHidden = true
                self?.viewModeBtn.image = UIImage(systemName: "chart.xyaxis.line")
            } else {
                self?.tableChart.isHidden = true
                self?.lineChart.isHidden = false
                self?.viewModeBtn.image = UIImage(systemName: "list.bullet")
            }
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        viewModel.fetchWeather()
    }
    
    @IBAction func toggleViewMode(_ sender: Any) {
        viewModel.toggleViewMode()
    }

}
