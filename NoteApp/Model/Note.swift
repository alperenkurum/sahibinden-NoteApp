//
//  Note.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 16.09.2025.
//
import UIKit

struct Note: Codable, Hashable, Identifiable{
    var id: UUID
    var title: String
    var text: String
    var check: Bool = false
}

enum Section{
    case main
}

extension Note {
    init(from entity: NoteCoreData) {
        self.title = entity.title ?? ""
        self.text = entity.context ?? ""
        self.check = entity.selected
        self.id = UUID(uuidString: entity.id ?? UUID().uuidString) ?? UUID()
    }
}

extension NoteCoreData {
    func convert(from note: Note) {
        self.title = note.title
        self.context = note.text
        self.selected = note.check
    }
}
