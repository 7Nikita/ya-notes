//
//  LoadNotesDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CoreData
import CocoaLumberjack

class LoadNotesDBOperation: BaseDBOperation {
    
    private let backgroundContext: NSManagedObjectContext
    
    var result: [Note]?
    
    init(notebook: FileNotebook, backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        fetchData().forEach { note in notebook.add(note) }
        result = notebook.notes
        finish()
    }
    
    func fetchData() -> [Note] {
        var loadedNotes = [Note]()
        let request = NSFetchRequest<NoteCD>(entityName: "NoteCD")
        let sortDescriptor = NSSortDescriptor(key: "uid", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            let fetchResult = try backgroundContext.fetch(request)
            for noteObject in fetchResult {
                let color = UIColor.init(red: CGFloat(noteObject.colorRed),
                                         green: CGFloat(noteObject.colorGreen),
                                         blue: CGFloat(noteObject.colorBlue),
                                         alpha: CGFloat(noteObject.colorAlpha))
                let importance = Note.Importance(rawValue: noteObject.importance!)
                let note = Note(uid: noteObject.uid!,
                                title: noteObject.title!,
                                content: noteObject.content!,
                                color: color,
                                importance: importance!,
                                selfDestructionDate: noteObject.destructionDate)
                loadedNotes.append(note)
            }
        } catch {
            DDLogError(error.localizedDescription)
        }
        return loadedNotes
    }

}
