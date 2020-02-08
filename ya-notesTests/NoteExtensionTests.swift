//
//  FileNotebookTests.swift
//  ya-notesTests
//
//  Created by Nikita Pekurin on 2/1/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import XCTest
@testable import ya_notes

class NoteExtensionTests: XCTestCase {
    
    func testNoteExtensionFullNoteParse() {
        let note = Note(
            title: "Test",
            content: "Test note",
            color: UIColor.red,
            importance: Note.Importance.unimportant,
            selfDestructionDate: Date()
        )
        
        let noteJson = note.json
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertEqual(parsedNote?.title, note.title)
        XCTAssertEqual(parsedNote?.content, note.content)
        XCTAssertEqual(parsedNote?.color, note.color)
        XCTAssertEqual(parsedNote?.importance, note.importance)
        XCTAssertEqual(parsedNote?.selfDestructionDate?.timeIntervalSince1970,
                       note.selfDestructionDate?.timeIntervalSince1970)
    }
    
    func testNoteExtensionNoteWithoutColorParse() {
        let note = Note(
            title: "Test",
            content: "Test note",
            importance: Note.Importance.unimportant,
            selfDestructionDate: Date()
        )
        
        let noteJson = note.json
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertEqual(parsedNote?.title, note.title)
        XCTAssertEqual(parsedNote?.content, note.content)
        XCTAssertEqual(parsedNote?.color, UIColor.white)
        XCTAssertEqual(parsedNote?.importance, note.importance)
        XCTAssertEqual(parsedNote?.selfDestructionDate?.timeIntervalSince1970,
                       note.selfDestructionDate?.timeIntervalSince1970)
    }
    
    func testNoteExtensionNoteWithoutDestructionDateParse() {
        let note = Note(
            title: "Test",
            content: "Test note",
            color: UIColor.red,
            importance: Note.Importance.unimportant
        )
        
        let noteJson = note.json
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote?.selfDestructionDate)
    }
    
    func testNoteExtensionNoteWithoutTitleParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson.removeValue(forKey: "title")
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
    func testNoteExtensionNoteWithoutContentParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson.removeValue(forKey: "content")
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
    func testNoteExtensionNoteWithMisspelledTitleParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson["titl"] = "Test"
        noteJson.removeValue(forKey: "title")
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
    func testNoteExtensionNoteWithMisspelledContentParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson["contet"] = "Test note"
        noteJson.removeValue(forKey: "content")
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
    func testNoteExtensionNoteWithIncorrectTitleTypeParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson["title"] = 100
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
    func testNoteExtensionNoteWitchIncorrectContentTypeParse() {
        let note = Note(title: "Test", content: "Test note")
        
        var noteJson = note.json
        noteJson["content"] = 100
        
        let parsedNote = Note.parse(json: noteJson)
        
        XCTAssertNil(parsedNote)
    }
    
}
