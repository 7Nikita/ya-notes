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
    
    private let fileName = "Notes.json"
    private let cachesDirectoryPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    private var fileNotebookPath: URL {
        cachesDirectoryPath.appendingPathComponent(fileName)
    }
    
    private(set) var notes = [Note]()
    
    public func add(_ note: Note) {
        for (index, element) in notes.enumerated() {
            if element.uid == note.uid {
                notes[index] = note
                DDLogInfo("Note with id \(note.uid) is overwritten")
            }
        }
        notes.append(note)
        DDLogError("Note with id \(note.uid) is added")
    }
    
    public func remove(with uid: String) {
        notes.removeAll(where: { $0.uid == uid })
        DDLogInfo("Note with id \(uid) is removed")
    }
    
    public func saveToFile() {
        do {
            let notesJsonArray = notes.map { $0.json }
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
                        self.add(note)
                    }
                }
            }
            DDLogInfo("Notes are loaded from file")
        } catch let error {
            DDLogError("Unable to load notes from file: \(error.localizedDescription)")
        }
    }
    
}
