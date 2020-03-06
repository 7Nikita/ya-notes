//
//  AddEditNoteViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/8/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class NoteEditViewController : UIViewController {
    
    var selectedNote: Note? = nil
    
    var saveNoteHandler: ((Note) -> ())?
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var elementsStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
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
    weak var lastChosenPaletteView: PaletteView!
    
    @IBOutlet weak var destroyDateLabel: UILabel!
    @IBOutlet weak var destroyDateSwitch: UISwitch!
    @IBOutlet weak var destroyDatePicker: UIDatePicker! {
        didSet {
            destroyDatePicker.isHidden = true
        }
    }
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem! {
        didSet {
            saveBarButton.target = self
            saveBarButton.action = #selector(saveNote)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastChosenPaletteView = whitePaletteView
        initWithNote(note: selectedNote)
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
            navigationController?.pushViewController(colorPickerViewController, animated: true)
        }
    }
    
    private func initWithNote(note: Note?) {
        guard let note = selectedNote else { return }
        titleTextField.text = note.title
        contentTextView.text = note.content
        handleColorPickerColorChanged(of: note.color)
        customPaletteView.backgroundColor = note.color
        if let date = note.selfDestructionDate {
            destroyDateSwitch.isOn = true
            destroyDatePicker.isHidden = false
            destroyDatePicker.date = date
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
    
    @objc private func saveNote() {
        guard var title = titleTextField.text else { return }
        guard var content = contentTextView.text else { return }
        
        if title.isEmpty {
            title = "empty title"
        }
        if content.isEmpty {
            content = "empty content"
        }
        
        let uid = selectedNote?.uid ?? UUID().uuidString
        let color = lastChosenPaletteView.backgroundColor!
        let importance = selectedNote?.importance ?? .regular
        let destroyDate = destroyDateSwitch.isOn ? destroyDatePicker?.date : nil
        let note = Note(uid: uid, title: title, content: content, color: color,
                        importance: importance, selfDestructionDate: destroyDate)
        saveNoteHandler?(note)
        navigationController?.popViewController(animated: true)
    }
    
}

extension NoteEditViewController : ColorDelegate {
    func handleColorPickerColorChanged(of color: UIColor) {
        markChosenColor(for: customPaletteView)
        if lastChosenPaletteView.isGradient {
            lastChosenPaletteView.isGradient = false
            lastChosenPaletteView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }
        lastChosenPaletteView.backgroundColor = color
    }
}
