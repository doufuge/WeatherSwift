//
//  WeatherController.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import UIKit

class WeatherController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var viewModel = WeatherViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hud: Hud!
    @IBOutlet weak var lineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationItem.hidesBackButton = true
        viewModel.startUpdatingLocation()
        viewModel.onWeatherDataLoaded = { [weak self] in
            self?.tableView.reloadData()
            self?.lineChart.data = (self?.viewModel.data)!
        }
        viewModel.onLoadStatusChanged = { [weak self] in
            self?.hud.isHidden = self?.viewModel.loading == false
        }
        viewModel.onViewModeChanged = { [weak self] in
            if self?.viewModel.showTable == true {
                self?.tableView.isHidden = false
                self?.lineChart.isHidden = true
            } else {
                self?.tableView.isHidden = true
                self?.lineChart.isHidden = false
            }
        }
    }
    
    @IBAction func reload(_ sender: Any) {
        viewModel.fetchWeather()
    }
    
    @IBAction func toggleViewMode(_ sender: Any) {
        viewModel.toggleViewMode()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let item = viewModel.data[indexPath.row]
        cell.hourLabel.text = TimeUtil.format(item.hour)
        cell.tempLabel.text = "\(item.temp) \(item.tempUnit)"
        if indexPath.row % 2 == 0 {
            cell.container.backgroundColor = UIColor.yellow
        } else {
            cell.container.backgroundColor = UIColor.cyan
        }
        return cell
    }

}
