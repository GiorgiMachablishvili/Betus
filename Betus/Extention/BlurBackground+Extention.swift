//
//  FogyBackground+Extention.swift
//  Betus
//
//  Created by Gio's Mac on 25.11.24.
//

import UIKit

extension UIColor {
    // Creates a clear color with a specified alpha
    static func clearBlur(withAlpha alpha: CGFloat) -> UIColor {
        return UIColor(white: 1.0, alpha: alpha) // White color with specified alpha
    }

    // Example method to apply a clear blur effect to a view
    static func applyBlurToView(_ view: UIView, style: UIBlurEffect.Style = .light, cornerRadius: CGFloat = 0) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Ensure it resizes
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.layer.masksToBounds = true

        view.addSubview(blurEffectView)
    }
}

