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
    
    let githubService = GithubService()
    
    var result: SaveNotesBackendResult?
    var notes: [Note]?
    
    init(notes: [Note]) {
        self.notes = notes
        super.init()
    }
    
    override func main() {
        guard NetworkService.isConnectedToNetwork() else {
            result = .failure(.unreachable)
            finish()
            return
        }
        
        if (UserDefaults.standard.object(forKey: "gistId") as? String) != nil {
            githubService.updateGists(notes: notes)
        } else {
            githubService.uploadGists(notes: notes)
        }
        result = .success
        finish()
    }
}
