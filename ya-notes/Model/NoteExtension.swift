//
//  NoteExtension.swift
//  ya-notes
//
//  Created by Nikita Pekurin on 1/22/20.
//  Copyright © 2020 Nikita Pekurin. All rights reserved.
//

import UIKit.UIColor

extension Note {
    
    private static let uid = "uid"
    private static let color = "color"
    private static let title = "title"
    private static let content = "content"
    private static let importance = "importance"
    private static let selfDestructionDate = "selfDestructionDate"
    
    var json: [String: Any] {
        var json: [String: Any] = [
            Note.uid: uid,
            Note.title: title,
            Note.content: content,
        ]
        
        if color != .white {
            json[Note.content] = getComponentsFromColor(color: color)
        }
        
        if importance != .regular {
            json[Note.importance] = importance.rawValue
        }
        
        if let selfDestructionDate = selfDestructionDate {
            json[Note.selfDestructionDate] = selfDestructionDate.timeIntervalSince1970
        }
        
        return json
    }
    
    static func parse(json: [String: Any]) -> Note? {
        guard
            let uid = json[Note.uid] as? String,
            let title = json[Note.title] as? String,
            let content = json[Note.content] as? String
            else {
                return nil
        }
        
        var importance = Importance.regular
        if let jsonImportance = json[Note.importance] as? String {
            importance = Importance(rawValue: jsonImportance) ?? Importance.regular
        }
        
        var destructionDate: Date? = nil
        if let jsonDestructionDate = json[Note.selfDestructionDate] as? TimeInterval {
            destructionDate = Date(timeIntervalSince1970: jsonDestructionDate)
        }
        
        var color = UIColor.white
        if let jsonComponents = json[Note.color] as? [String: Double] {
            color = getColorFromComponents(components: jsonComponents)
        }
        
        return Note(
            uid: uid,
            title: title,
            content: content,
            color: color,
            importance: importance,
            selfDestructionDate: destructionDate
        )
    }
    
    private static func getColorFromComponents(components: [String: Double]) -> UIColor {
        guard
            let red = components[ColorModel.red.rawValue],
            let green = components[ColorModel.green.rawValue],
            let blue = components[ColorModel.blue.rawValue],
            let alpha = components[ColorModel.alpha.rawValue]
            else {
                return .white
        }
        return UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }
    
    private func getComponentsFromColor(color: UIColor) -> [String: Double] {
        var r = CGFloat(), g = CGFloat(), b = CGFloat(), a = CGFloat()
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return [
            ColorModel.red.rawValue : Double(r),
            ColorModel.green.rawValue: Double(g),
            ColorModel.blue.rawValue: Double(b),
            ColorModel.alpha.rawValue: Double(a)
        ]
    }
    
    private enum ColorModel: String {
        case red
        case green
        case blue
        case alpha
    }
    
}
