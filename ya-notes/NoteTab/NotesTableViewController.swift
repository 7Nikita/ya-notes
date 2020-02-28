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
    private let notesQueue = OperationQueue()
    private let dbQueue = OperationQueue()
    private let backendQueue = OperationQueue()
    
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
        loadNotes()
        notesTableView.register(UINib(nibName: "NoteTableViewCell", bundle: nil), forCellReuseIdentifier: "noteCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesTableView.reloadData()
    }
    
    @objc private func editButtonTapped() {
        notesTableView.isEditing = !notesTableView.isEditing
    }
    
    @objc private func addButtonTapped() {
        let noteEditViewController = createNoteEditViewController()
        navigationController?.pushViewController(noteEditViewController, animated: true)
    }
    
    private func loadNotes() {
        let loadNotesOperation = LoadNotesOperation(notebook: fileNotebook,
                                                    backendQueue: backendQueue,
                                                    dbQueue: dbQueue)
        loadNotesOperation.completionBlock = {
            OperationQueue.main.addOperation {
                self.notesTableView.reloadData()
            }
        }
        notesQueue.addOperation(loadNotesOperation)
    }
    
    private func createNoteEditViewController() -> NoteEditViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let noteEditViewController = storyBoard.instantiateViewController(identifier: "NoteEditViewController")
            as! NoteEditViewController
        noteEditViewController.saveNoteHandler = { [weak self] note in
            if let self = self {
                let saveNoteOperation = SaveNoteOperation(note: note,
                                                          notebook: self.fileNotebook,
                                                          backendQueue: self.backendQueue,
                                                          dbQueue: self.dbQueue)
                saveNoteOperation.completionBlock = {
                    OperationQueue.main.addOperation {
                        self.notesTableView.reloadData()
                    }
                }
                self.notesQueue.addOperation(saveNoteOperation)
            }
        }
        return noteEditViewController
    }
}

extension NotesTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let noteUid = fileNotebook.notes[indexPath.row].uid
            removeNote(for: noteUid, cellForRowAt: indexPath)
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
        let noteEditViewController = createNoteEditViewController()
        noteEditViewController.selectedNote = fileNotebook.notes[indexPath.row]
        navigationController?.pushViewController(noteEditViewController, animated: true)
    }
    
    
    private func removeNote(for noteUid: String, cellForRowAt indexPath: IndexPath) {
        let removeNoteOperation = RemoveNoteOperation(noteId: noteUid,
                                                      notebook: fileNotebook,
                                                      backendQueue: backendQueue,
                                                      dbQueue: dbQueue)
        removeNoteOperation.completionBlock = {
            OperationQueue.main.addOperation {
                self.notesTableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        notesQueue.addOperation(removeNoteOperation)
    }
}
