//
//  LaunchController.swift
//  WeatherSwift
//
//  Created by Johny Fu on 2025/2/22.
//

import UIKit
import Lottie

class SplashController: UIViewController {

    override func viewDidLoad() {
        let animationView = LottieAnimationView(name: "splash")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 280),
            animationView.heightAnchor.constraint(equalToConstant: 280)
        ])
        
        animationView.play()
        animationView.loopMode = .loop
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.performSegue(withIdentifier: "segueWeather", sender: self)
        }
    }
    
}
