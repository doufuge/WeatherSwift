//
//  LineChart.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/23.
//

import UIKit

class LineChart: UIView {
    
    var data: [WeatherItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        drawAxis(context)
    }
    
    private func drawAxis(_ context: CGContext) {
        if data.isEmpty {
            return
        }

        context.move(to: CGPoint(x: LineChartConfig.startX, y: LineChartConfig.startY - 4 * LineChartConfig.yStep))
        context.addLine(to: CGPoint(x: LineChartConfig.startX, y: LineChartConfig.startY))
        context.addLine(to: CGPoint(x: (data.count + 1) * LineChartConfig.xStep, y: LineChartConfig.startY))
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.red.cgColor)
        context.strokePath()
    }
    
}

struct LineChartConfig {
    static let startX = 50
    static let startY = 200
    static let xStep = 30
    static let yStep = 50
}
