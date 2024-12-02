//
//  NonPropagatingButton.swift
//  Betus
//
//  Created by Gio's Mac on 02.12.24.
//

import UIKit

class NonPropagatingButton: UIButton {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? self : nil
    }
}
