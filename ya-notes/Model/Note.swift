//
//  Note.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 1/22/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit

struct Note {
    let uid: String
    let title: String
    let content: String
    let color: UIColor
    let importance: Importance
    let selfDestructionDate: Date?
    
    enum Importance: String {
        case regular
        case important
        case unimportant
    }
    
    init(
        uid: String = UUID().uuidString,
        title: String,
        content: String,
        color: UIColor = UIColor.white,
        importance: Importance = .regular,
        selfDestructionDate: Date? = nil
    ) {
        self.uid = uid
        self.title = title
        self.content = content
        self.color = color
        self.importance = importance
        self.selfDestructionDate = selfDestructionDate
    }
}
