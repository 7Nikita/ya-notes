//
//  RemoveNoteOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData

class RemoveNoteOperation: AsyncOperation {
    private let noteId: String
    private let notebook: FileNotebook
    private let removeFromDB: RemoveNoteDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(noteId: String,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        self.noteId = noteId
        self.notebook = notebook
        self.dbQueue = dbQueue
        
        removeFromDB = RemoveNoteDBOperation(noteId: noteId, notebook: notebook, backgroundContext: backgroundContext)
        
        super.init()
        
        removeFromDB.completionBlock = {
            let removeFromBackend = SaveNotesBackendOperation(notes: notebook.notes)
            removeFromBackend.completionBlock = {
                switch removeFromBackend.result! {
                case .success:
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(removeFromBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(removeFromDB)
    }
}
