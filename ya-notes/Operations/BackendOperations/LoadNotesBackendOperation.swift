//
//  LoadNotesBackendOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation
import CocoaLumberjack

enum LoadNotesBackendResult {
    case success([Note])
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseBackendOperation {
    
    let githubService = GithubService()
    
    var result: LoadNotesBackendResult?
    
    override func main() {
        guard NetworkService.isConnectedToNetwork() else {
            result = .failure(.unreachable)
            finish()
            return
        }
        
        func getGistContentCompletionBlock(value: [Note]?) {
            if let value = value {
                result = .success(value)
            } else {
                result = .failure(.unreachable)
            }
            finish()
        }
        
        githubService.getGistDbId(completion: { [weak self] in
            self?.githubService.getGistContent(completion: getGistContentCompletionBlock)
        })
        
    }
}
