//
//  NotesTableViewController.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/16/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

class NotesTableViewController: UIViewController {
    
    private let fileNotebook = FileNotebook()
    
    @IBOutlet weak var notesTableView: UITableView! {
        didSet {
            notesTableView.delegate = self
            notesTableView.dataSource = self
        }
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem! {
        didSet {
            editButton.target = self
            editButton.action = #selector(editButtonTapped)
        }
    }
    
    @IBOutlet weak var addButton: UIBarButtonItem! {
        didSet {
            addButton.target = self
            addButton.action = #selector(addButtonTapped)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
        fileNotebook.add(Note(title: "kek", content: "rofl"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesTableView.reloadData()
    }
    
    @objc private func editButtonTapped() {
        notesTableView.isEditing = !notesTableView.isEditing
    }
    
    @objc private func addButtonTapped() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let noteEditViewController = storyBoard.instantiateViewController(identifier: "NoteEditViewController")
        navigationController?.pushViewController(noteEditViewController, animated: true)
    }
}

extension NotesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fileNotebook.remove(with: fileNotebook.notes[indexPath.row].uid)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileNotebook.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = fileNotebook.notes[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.colorView.backgroundColor = note.color
        cell.titleLable.text = note.title
        cell.contentLabel.text = note.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
