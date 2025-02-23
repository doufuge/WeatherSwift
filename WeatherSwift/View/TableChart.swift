//
//  TableChart.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/23.
//

import Foundation
import UIKit

class TableChart: UITableView, UITableViewDataSource, UITableViewDelegate {

    var data: [WeatherItem] = [] {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.dataSource = self
        self.delegate = self
        let nib = UINib(nibName: "WeatherCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "WeatherCell")
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        let item = data[indexPath.row]
        cell.hourLabel.text = TimeUtil.format(item.hour)
        cell.tempLabel.text = "\(item.temp) \(item.tempUnit)"
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.yellow
        } else {
            cell.backgroundColor = UIColor.cyan
        }
        return cell
    }
    
}
