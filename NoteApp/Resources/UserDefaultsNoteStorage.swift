//
//  UserDefaultsConfig.swift
//  NoteApp
//
//  Created by Ibrahim Alperen Kurum on 10.11.2025.
//

import Foundation



class UserDefaultsNoteStorage: NoteStorage {
    func updateNote(with note: Note) {
        var notes = fetchAllNotes()
        if let index = notes.firstIndex(where: {$0.id == note.id}) {
            notes[index] = note
            saveUserDefaults(notes: notes)
        }
    }
    
    func deleteNote(noteId: UUID) {
        var notes = fetchAllNotes()
        if let index = notes.firstIndex(where:{ $0.id == noteId }) {
            notes.remove(at: index)
        }
        saveUserDefaults(notes: notes)
    }
    
    func saveNote(note: Note) {
        var notes = fetchAllNotes()
        notes.append(note)
        saveUserDefaults(notes: notes)
    }
    
    func fetchAllNotes() -> [Note] {
        if let data = UserDefaults.standard.value(forKey: "notes") as? Data {
            do{
                return try JSONDecoder().decode([Note].self, from: data)
            }catch {
                print("\nEror has occured at decoding. Error: \(error)")
                return []
            }
        } else {
            print("No notes found in UserDefaults")
            return []
        }
    }
    
    private func saveUserDefaults(notes: [Note]) {
        do {
            let encodedData = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(encodedData, forKey: "notes")
            print("Notes saved")
        } catch {
            print("Failed to encode notes:", error)
        }
    }

}
