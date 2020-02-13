//
//  PaletteView.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/9/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

@IBDesignable
class PaletteView: UIView {
    
    @IBInspectable var isChosen: Bool = false
    @IBInspectable var isGradient: Bool = false
    @IBInspectable var borderWidth: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if isGradient {
            putSpectrumImage(rect: rect)
        }
        
        if isChosen {
            drawFlag(rect: rect)
        }
        
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func drawFlag(rect: CGRect) {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.width * 0.75, y: rect.height * 0.25)
        
        path.lineWidth = 1.5
        path.move(to: CGPoint(x: center.x - 10.0, y: center.y))
        path.addLine(to: CGPoint(x: center.x, y: center.y + 9.0))
        path.addLine(to: CGPoint(x: center.x + 8.0, y: center.y - 7.0))
        
        if backgroundColor == UIColor.black {
            UIColor.white.setStroke()
        }
        
        path.stroke()
    }
    
    private func putSpectrumImage(rect: CGRect) {
        let spectrumImageName = "Spectrum"
        let spectrumImage = UIImage(named: spectrumImageName)?.cgImage
        let imageLayer = CALayer()
        imageLayer.frame = rect
        imageLayer.contents = spectrumImage
        self.layer.addSublayer(imageLayer)
    }
    
}
