//
//  CoreDataNoteStorage.swift
//  NoteApp
//
//  Created by Ibrahim Alperen Kurum on 10.11.2025.
//

import Foundation

class CoreDataNoteStorage: NoteStorage {
    func updateNote(with note: Note) {
//        var notes = fetchAllNotes()
//        notes[index] = note
        if let noteEntity = DataManager.shared.findNote(id: note.id.uuidString) {
            noteEntity.convert(from: note)
            DataManager.shared.saveContext()
        }
    }
    
    func deleteNote(noteId: UUID) {
//        var notes = fetchAllNotes()
        //let noteId = notes[noteIndex].id
//        notes.removeAll { $0.id == noteId }
        if let noteToDelete = DataManager.shared.findNote(id: noteId.uuidString){
            let context = DataManager.shared.persistentContainer.viewContext
            context.delete(noteToDelete)
            DataManager.shared.saveContext()
        }
    }
    
    func saveNote(note: Note) {
        let noteEntity = DataManager.shared.note(title: note.title, context: note.text, checked: note.check, id: note.id.uuidString)
//        notes.addNewNote(Note: note)
        DataManager.shared.saveContext()
    }
    
    func fetchAllNotes() -> [Note]{
        let notesCoreData = DataManager.shared.notes()
        let notes = notesCoreData.map { Note(from: $0) }
        return notes
    }
}
