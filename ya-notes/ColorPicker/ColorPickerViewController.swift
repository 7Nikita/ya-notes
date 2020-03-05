//
//  ColorPickerViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/9/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit


class ColorPickerViewController: UIViewController {
    
    var lastSelectedColor: UIColor? = nil
    weak var delegate: ColorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lastSelectedColor = lastSelectedColor {
            updateCurrentColor(for: lastSelectedColor)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        colorPickerView.setNeedsDisplay()
    }
    
    @IBOutlet weak var colorPreview: UIView! {
        didSet {
            colorPreview.layer.borderColor = UIColor.black.cgColor
            colorPreview.layer.borderWidth = 1.0
            colorPreview.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var colorView: UIView! {
        didSet {
            colorView.layer.borderColor = UIColor.black.cgColor
            colorView.layer.borderWidth = 1.0
            colorView.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var colorHexLabel: UILabel! {
        didSet {
            colorHexLabel.text = UIColor.white.hexString()
        }
    }
    
    @IBOutlet weak var colorPickerView: ColorPickerView! {
        didSet {
            colorPickerView.layer.borderColor = UIColor.black.cgColor
            colorPickerView.layer.borderWidth = 1.0
            colorPickerView.whenColorDidChange = { [weak self] color in
                guard let alpha = self?.brightnessSlider.value else { return }
                let colorWithAlpha = color.withAlphaComponent(CGFloat(alpha))
                self?.updateCurrentColor(for: colorWithAlpha)
            }
        }
    }
    
    @IBOutlet weak var brightnessSlider: UISlider!
    
    @IBAction func brightnessSliderValueChanged(_ sender: UISlider) {
        let alpha = CGFloat(brightnessSlider.value)
        guard let colorWithAlpha = lastSelectedColor?.withAlphaComponent(alpha) else { return }
        updateCurrentColor(for: colorWithAlpha)
    }
    
    @IBAction func doneButtonePressed(_ sender: UIButton) {
        if let lastSelectedColor = lastSelectedColor {
            delegate?.handleColorPickerColorChanged(of: lastSelectedColor)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func updateCurrentColor(for color: UIColor) {
        colorHexLabel.text = color.hexString()
        colorView.backgroundColor = color
        lastSelectedColor = color
    }
    
}
