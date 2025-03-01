//
//  HudView.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import Foundation
import UIKit
import Lottie
import Combine

class Hud: UIView, ObservableObject {
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    @Published var isLoading: Bool = false {
        didSet {
            self.isHidden = !isLoading
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        setupLottie()
    }
    
    private func setupLottie() {
        let animationView = LottieAnimationView(name: "hud")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 64),
            animationView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        animationView.play()
        animationView.loopMode = .loop
    }
    
}
