//
//  Animations.swift
//  21byHayyimVital
//
//  Created by vitasiy on 27/06/2023.
//

import UIKit

func pulsate(for view: UIView) {
    let alpha = CASpringAnimation(keyPath: "opacity")
    alpha.fromValue = 0
    alpha.toValue = 1
    alpha.duration = 3
    alpha.damping = 1
    
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.fromValue = 0.95
    pulse.toValue = 1
    pulse.duration = 0.6
    pulse.autoreverses = true
    pulse.repeatCount = 5
    pulse.initialVelocity = 0.5
    pulse.damping = 1
    
    DispatchQueue.main.asyncAfter(deadline: .now()) {
        view.layer.add(pulse, forKey: nil)
        view.layer.add(alpha, forKey: nil)
    }
}
