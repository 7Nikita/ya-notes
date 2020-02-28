//
//  SaveNoteOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDB: SaveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        self.dbQueue = dbQueue
        
        saveToDB = SaveNoteDBOperation(note: note, notebook: notebook)
        
        super.init()
        
        saveToDB.completionBlock = {
            let saveToBackend = SaveNotesBackendOperation(notes: notebook.notes)
            saveToBackend.completionBlock = {
                switch saveToBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(saveToBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(saveToDB)
    }
}
