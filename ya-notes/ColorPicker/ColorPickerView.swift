//
//  ColorPickerView.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/9/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

@IBDesignable
class ColorPickerView: UIView {
    
    @IBInspectable var elementSize: CGFloat = 3.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    var mainPaletteRect = CGRect.zero
    var whenColorDidChange: ((_ color: UIColor) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.clipsToBounds = true
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.touchedColor(gestureRecognizer:)))
        touchGesture.minimumPressDuration = 0
        touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        self.addGestureRecognizer(touchGesture)
    }
    
    @objc func touchedColor(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self)
        let color = getColorAtPoint(point: point)
        self.whenColorDidChange?(color)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        mainPaletteRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        
        for y in stride(from: CGFloat(0), to: mainPaletteRect.height, by: elementSize) {
            
            var saturation = y < mainPaletteRect.height / 2.0 ? CGFloat(2 * y) / mainPaletteRect.height : 2.0 * CGFloat(mainPaletteRect.height - y) / mainPaletteRect.height
            saturation = CGFloat(powf(Float(saturation), y < mainPaletteRect.height / 2.0 ? 2.0 : 1.3))
            let brightness = y < mainPaletteRect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(mainPaletteRect.height - y) / mainPaletteRect.height
            
            for x in stride(from: (0 as CGFloat), to: mainPaletteRect.width, by: elementSize) {
                let hue = x / mainPaletteRect.width
                
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x: x, y: y + mainPaletteRect.origin.y,
                                     width: elementSize, height: elementSize))
            }
        }
    }
    
    func getColorAtPoint(point: CGPoint) -> UIColor {
        var roundedPoint = CGPoint(x: elementSize * CGFloat(Int(point.x / elementSize)),
                                   y: elementSize * CGFloat(Int(point.y / elementSize)))
        
        let hue = roundedPoint.x / self.bounds.width
        
        if mainPaletteRect.contains(point){
            roundedPoint.y -= mainPaletteRect.origin.y
            
            var saturation = roundedPoint.y < mainPaletteRect.height / 2.0 ? CGFloat(2 * roundedPoint.y) / mainPaletteRect.height
                : 2.0 * CGFloat(mainPaletteRect.height - roundedPoint.y) / mainPaletteRect.height
            
            saturation = CGFloat(powf(Float(saturation), roundedPoint.y < mainPaletteRect.height / 2.0 ? 2.0 : 1.3))
            let brightness = roundedPoint.y < mainPaletteRect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(mainPaletteRect.height - roundedPoint.y) / mainPaletteRect.height
            
            return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        }
        return UIColor.white
    }
    
}
