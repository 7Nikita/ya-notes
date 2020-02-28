//
//  LoadNotesOperation.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 2/26/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

class LoadNotesOperation: AsyncOperation {
    private let notebook: FileNotebook
    private let loadFromDB: LoadNotesDBOperation
    private let dbQueue: OperationQueue
    
    private(set) var result: Bool? = false
    
    init(notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.notebook = notebook
        self.dbQueue = dbQueue
        
        loadFromDB = LoadNotesDBOperation(notebook: notebook)
        
        super.init()
        
        loadFromDB.completionBlock = {
            let loadFromBackend = LoadNotesBackendOperation()
            loadFromBackend.completionBlock = {
                switch loadFromBackend.result! {
                case .success:
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
}
