//
//  RemoveNoteDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class RemoveNoteDBOperation: BaseDBOperation {
    
    private let backgroundContext: NSManagedObjectContext
    
    let noteId: String
    
    init(noteId: String, notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.noteId = noteId
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        removeNoteFromCD()
        notebook.remove(with: noteId)
        finish()
    }
    
    func removeNoteFromCD() {
        let request = NSFetchRequest<NoteCD>(entityName: "NoteCD")
        request.predicate = NSPredicate(format: "uid == %@", noteId)
        do {
            let fetchResult = try backgroundContext.fetch(request)
            if !fetchResult.isEmpty {
                backgroundContext.delete(fetchResult.first!)
                try backgroundContext.save()
                DDLogInfo("Note with uid \(noteId) was removed from CoreData.")
            }
        } catch {
            DDLogError(error.localizedDescription)
        }
    }
    
}
