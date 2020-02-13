//
//  AddEditNoteViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/8/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class NoteEditViewController : UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var elementsStackView: UIStackView!
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.layer.borderWidth = 1.0
            contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var whitePaletteView: PaletteView!
    @IBOutlet weak var redPaletteView: PaletteView!
    @IBOutlet weak var greenPaletteView: PaletteView!
    @IBOutlet weak var customPaletteView: PaletteView!
    weak var lastChosenPaletteView: PaletteView! = nil
    
    @IBOutlet weak var destroyDateLabel: UILabel!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker! {
        didSet {
            destroyDatePicker.isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastChosenPaletteView = whitePaletteView
    }
    
    @IBAction func destroyDateSwitchValueChanged(_ sender: UISwitch) {
        destroyDatePicker.isHidden = !destroyDateSwitch.isOn
    }
    
    @IBAction func commonColorTapped(_ sender: UITapGestureRecognizer) {
        if sender.view?.backgroundColor != nil {
            markChosenColor(for: sender.view as? PaletteView)
        }
    }
    
    @IBAction func customColorLongTapped(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let colorPickerViewController = ColorPickerViewController()
            colorPickerViewController.lastSelectedColor = customPaletteView.backgroundColor
            colorPickerViewController.delegate = self
            present(colorPickerViewController, animated: true)
        }
    }
    
    
    private func markChosenColor(for view: PaletteView?) {
        guard let view = view else { return }
        lastChosenPaletteView.isChosen = false
        view.isChosen = true
        view.setNeedsDisplay()
        lastChosenPaletteView.setNeedsDisplay()
        lastChosenPaletteView = view
    }
    
}

extension NoteEditViewController : ColorDelegate {
    func passValue(of color: UIColor) {
        markChosenColor(for: customPaletteView)
        if lastChosenPaletteView.isGradient {
            lastChosenPaletteView.isGradient = false
            lastChosenPaletteView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        lastChosenPaletteView.backgroundColor = color
    }
}
