//
//  RemoveNoteDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

class RemoveNoteDBOperation: BaseDBOperation {
    let noteId: String
    
    init(noteId: String, notebook: FileNotebook) {
        self.noteId = noteId
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.remove(with: noteId)
        notebook.saveToFile()
        finish()
    }
}
