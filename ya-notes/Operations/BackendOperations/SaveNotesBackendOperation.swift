//
//  SaveNotesBackendOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

enum SaveNotesBackendResult {
    case success
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var notes: [Note]?
    
    init(notes: [Note]) {
        self.notes = notes
        super.init()
    }
    
    override func main() {
        result = .failure(.unreachable)
        finish()
    }
}
