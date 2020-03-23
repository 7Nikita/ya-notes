//
//  GistFile.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 3/7/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import Foundation

struct GistFile: Codable {
    let filename: String
    let rawUrl: String

    enum CodingKeys: String, CodingKey {
        case filename
        case rawUrl = "raw_url"
    }
}
