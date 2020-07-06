//
//  SaveNoteDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class SaveNoteDBOperation: BaseDBOperation {
    
    private let backgroundContext: NSManagedObjectContext
    
    private let note: Note
    
    init(note: Note, notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.note = note
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        saveNoteToCD()
        notebook.add(note)
        finish()
    }
    
    func saveNoteToCD() {
        
        let request = NSFetchRequest<NoteCD>(entityName: "NoteCD")
        request.predicate = NSPredicate(format: "uid == %@", note.uid)
        do {
            let fetchResult = try backgroundContext.fetch(request)
            for noteObject in fetchResult {
                backgroundContext.delete(noteObject)
                try backgroundContext.save()
                DDLogInfo("Note with uid \(note.uid) was removed from CoreData.")
            }
        } catch {
            DDLogError(error.localizedDescription)
        }
        
        let noteCD = NoteCD(context: backgroundContext)
        noteCD.uid = note.uid
        noteCD.title = note.title
        noteCD.content = note.content
        noteCD.importance = note.importance.rawValue
        noteCD.destructionDate = note.selfDestructionDate
        let noteColorComponents = note.getComponentsFromColor(color: note.color)
        noteCD.colorRed = noteColorComponents[ColorModel.red.rawValue]!
        noteCD.colorGreen = noteColorComponents[ColorModel.green.rawValue]!
        noteCD.colorBlue = noteColorComponents[ColorModel.blue.rawValue]!
        noteCD.colorAlpha = noteColorComponents[ColorModel.alpha.rawValue]!
        
        backgroundContext.performAndWait {
            do {
                try backgroundContext.save()
                DDLogInfo("Note with uid \(note.uid) was saved to CoreData.")
            } catch {
                DDLogError(error.localizedDescription)
            }
        }
    }
}
