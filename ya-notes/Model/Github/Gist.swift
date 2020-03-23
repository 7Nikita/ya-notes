//
//  Gist.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/7/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

struct Gist: Codable {
    let id: String
    let files: [String: GistFile]
}
