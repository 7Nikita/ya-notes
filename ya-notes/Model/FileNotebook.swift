//
//  FileNotebook.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 1/22/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {
    
    enum FileNotebookError: Error {
        case NoteAlreadyExists(message: String)
    }
    
    private let fileName = "Notes.json"
    private let cachesDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    private var fileNotebookPath: URL {
        cachesDirectoryPath.appendingPathComponent(fileName)
    }
    
    private(set) var notes = [String: Note]()
    
    public func add(_ note: Note) throws {
        guard notes[note.uid] == nil else {
            DDLogError("Note with id \(note.uid) could not be added, note with this uuid already exists")
            throw FileNotebookError.NoteAlreadyExists(message: "Note with \(note.uid) uid already exists")
        }
        notes[note.uid] = note
        DDLogError("Note with id \(note.uid) is added")
    }
    
    public func remove(with uid: String) {
        DDLogInfo("Note with id \(uid) is removed")
        notes.removeValue(forKey: uid)
    }
    
    public func saveToFile() {
        do {
            let notesJsonArray = notes.map { $0.value.json }
            let data = try JSONSerialization.data(withJSONObject: notesJsonArray, options: [])
            FileManager.default.createFile(atPath: fileNotebookPath.path, contents: data, attributes: nil)
            DDLogInfo("Notes are saved to file")
        } catch let error {
            DDLogError("Unable to save notes to file: \(error.localizedDescription)")
        }
    }
    
    public func loadFromFile() {
        notes.removeAll()
        do {
            if let data = FileManager.default.contents(atPath: fileNotebookPath.path),
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                for noteJson in jsonData {
                    if let note = Note.parse(json: noteJson) {
                        try self.add(note)
                    }
                }
            }
            DDLogInfo("Notes are loaded from file")
        } catch let error {
            DDLogError("Unable to load notes from file: \(error.localizedDescription)")
        }
    }
    
}
