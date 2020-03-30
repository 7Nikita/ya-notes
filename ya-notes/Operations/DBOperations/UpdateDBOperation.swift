//
//  UpdateDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/28/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class UpdateDBOperation: BaseDBOperation {
    
    private let backgroundContext: NSManagedObjectContext
    
    init(notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        updateCDNotes()
        finish()
    }

    func updateCDNotes() {
        let request = NSFetchRequest<NoteCD>(entityName: "NoteCD")
        request.returnsObjectsAsFaults = false
        do {
            let results = try backgroundContext.fetch(request)
            for managedObject in results {
                backgroundContext.delete(managedObject)
                try backgroundContext.save()
            }
        } catch let error{
            DDLogError(error.localizedDescription)
        }
        
        for note in notebook.notes {
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
    
}

