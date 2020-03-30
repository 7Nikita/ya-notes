//
//  LoadNotesOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDB: LoadNotesDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue,
         backgroundContext: NSManagedObjectContext) {
        self.notebook = notebook
        self.dbQueue = dbQueue
        
        loadFromDB = LoadNotesDBOperation(notebook: notebook, backgroundContext: backgroundContext)
        
        super.init()
        loadFromDB.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation()
            loadFromBackend.completionBlock = {
                switch loadFromBackend.result! {
                case .success(let notes):
                    notebook.update(for: notes)
                    let updateDBOperation = UpdateDBOperation(notebook: notebook, backgroundContext: backgroundContext)
                    dbQueue.addOperation(updateDBOperation)
//                    self.updateCDNotes(backgroundContext: backgroundContext)
                    self.result = true
                case .failure:
                    self.result = false
                }
                self.finish()
            }
            backendQueue.addOperation(loadFromBackend)
        }
    }
    
    override func main() {
        dbQueue.addOperation(loadFromDB)
    }
    
//    func updateCDNotes(backgroundContext: NSManagedObjectContext) {
//        let request = NSFetchRequest<NoteCD>(entityName: "NoteCD")
//        request.returnsObjectsAsFaults = false
//        do {
//            let results = try backgroundContext.fetch(request)
//            for managedObject in results {
//                backgroundContext.delete(managedObject)
//                try backgroundContext.save()
//            }
//        } catch let error{
//            DDLogError(error.localizedDescription)
//        }
//
//        for note in notebook.notes {
//            let noteCD = NoteCD(context: backgroundContext)
//            noteCD.uid = note.uid
//            noteCD.title = note.title
//            noteCD.content = note.content
//            noteCD.importance = note.importance.rawValue
//            noteCD.destructionDate = note.selfDestructionDate
//            let noteColorComponents = note.getComponentsFromColor(color: note.color)
//            noteCD.colorRed = noteColorComponents[ColorModel.red.rawValue]!
//            noteCD.colorGreen = noteColorComponents[ColorModel.green.rawValue]!
//            noteCD.colorBlue = noteColorComponents[ColorModel.blue.rawValue]!
//            noteCD.colorAlpha = noteColorComponents[ColorModel.alpha.rawValue]!
//
//            backgroundContext.performAndWait {
//                do {
//                    try backgroundContext.save()
//                    DDLogInfo("Note with uid \(note.uid) was saved to CoreData.")
//                } catch {
//                    DDLogError(error.localizedDescription)
//                }
//            }
//        }
//
//    }
}
