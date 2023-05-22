//
//  FatSlider.swift
//  MortgageSimple
//
//  Created by Faraz Malik on 22/05/2023.
//

import UIKit

class FatSlider: UISlider {
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.minX, y: bounds.minY, width: bounds.width, height: 20)
    }
}
