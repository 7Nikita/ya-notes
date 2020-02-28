//
//  LoadNotesDBOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

class LoadNotesDBOperation: BaseDBOperation {
    var result: [Note]?
    
    override func main() {
        notebook.loadFromFile()
        result = notebook.notes
        finish()
    }
}
