//
//  WeatherController.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import UIKit
import Combine
import SwinjectStoryboard

class WeatherController: UIViewController {
    
    var viewModel: WeatherViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    @IBOutlet weak var hud: Hud!
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var tableChart: TableChart!
    @IBOutlet weak var viewModeBtn: UIBarButtonItem!
    @IBOutlet weak var tipView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        viewModel.startUpdatingLocation()
        
        viewModel.state.$loading
            .assign(to: \.isLoading, on: hud)
            .store(in: &cancellables)
        
        viewModel.state.$data
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weatherItems in
                self?.lineChart.data = weatherItems
                self?.tableChart.data = weatherItems
            }
            .store(in: &cancellables)
        
        viewModel.state.$showTable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] showTable in
                self?.tableChart.isHidden = !showTable
                self?.lineChart.isHidden = showTable
                self?.viewModeBtn.image = UIImage(systemName: showTable ? "chart.xyaxis.line" : "list.bullet")
            }
            .store(in: &cancellables)
        
        viewModel.state.$uiEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiEvent in
                switch (uiEvent) {
                case .reload:
                    NSLog("reload")
                case .showTip(let message, let autoHide):
                    self?.showTip(message: message, autoHide: autoHide)
                case .none: break
                }
            }
            .store(in: &cancellables)
    }
    
    func showTip(message: String, autoHide: Bool) {
        tipView.alpha = 0
        tipView.isHidden = false
        tipLabel.text = message
        UIView.animate(withDuration: 0.3) {
            self.tipView.alpha = 1
            if autoHide {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.hideTip()
                }
            }
        }
    }
    
    func hideTip() {
        UIView.animate(withDuration: 0.3) {
            self.tipView.alpha = 0
            self.tipView.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cancellables.forEach { $0.cancel() }
    }
    
    @IBAction func reload(_ sender: Any) {
        viewModel.loadWeather()
    }
    
    @IBAction func toggleViewMode(_ sender: Any) {
        viewModel.toggleViewMode()
    }

}
