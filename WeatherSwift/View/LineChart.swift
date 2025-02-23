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
        
        if !data.isEmpty {
            let width = data.count * LineChartConfig.xStep + 300
            var currentFrame = self.frame
            currentFrame.size.width = CGFloat(width)
            self.frame = currentFrame
            self.clipsToBounds = false
        }
        
        drawAxis(context)
        drawXLabels(context)
        drawYLabels(context)
        drawWeatherPath(context)
        setupGestures()
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.addGestureRecognizer(pinchGesture)
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
    
    private func drawXLabels(_ context: CGContext) {
        context.setFillColor(UIColor.black.cgColor)
        let font = UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.black
                ]
        
        data.enumerated().forEach { index, item in
            let text = TimeUtil.formatHour(item.hour)
            let point = CGPoint(x: LineChartConfig.startX + index * LineChartConfig.xStep, y: LineChartConfig.startY + 4)
            text.draw(at: point, withAttributes: attributes)
        }
    }
    
    private func drawYLabels(_ context: CGContext) {
        context.setFillColor(UIColor.black.cgColor)
        let font = UIFont.systemFont(ofSize: 12)
        let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: UIColor.black
                ]
        for i in 0..<5 {
            let text = "\(i * 10)"
            let point = CGPoint(x: LineChartConfig.startX - 20, y: LineChartConfig.startY - i * LineChartConfig.yStep - 12)
            text.draw(at: point, withAttributes: attributes)
        }
    }
    
    private func drawWeatherPath(_ context: CGContext) {
        if !data.isEmpty {
            context.move(to: CGPoint(x: LineChartConfig.startX, y: LineChartConfig.startY - 5 * Int((data.first?.temp ?? 0))))
            data.enumerated().forEach { index, item in
                context.addLine(to: CGPoint(x: LineChartConfig.startX + index * LineChartConfig.xStep, y: LineChartConfig.startY - Int(item.temp * 5)))
            }
            context.setLineWidth(1)
            context.setStrokeColor(UIColor.green.cgColor)
            context.strokePath()
        }
    }
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        if gesture.state == .changed {
            self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.superview)
        }
    }
    
    @objc private func handlePinch(gesture: UIPinchGestureRecognizer) {
        let scale = gesture.scale
        if gesture.state == .changed {
            self.transform = self.transform.scaledBy(x: scale, y: scale)
        }
    }
    
}

struct LineChartConfig {
    static let startX = 50
    static let startY = 300
    static let xStep = 30
    static let yStep = 50
}
