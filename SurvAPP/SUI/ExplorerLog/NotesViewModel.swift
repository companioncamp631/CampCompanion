//
//  File.swift
//  SurvAPP
//
//  Created by D K on 08.07.2025.
//

import Foundation
// NotesViewModel.swift
import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    private let notesKey = "ExplorerLogNotes"

    init() {
        loadNotes()
    }

    func addOrUpdateNote(content: String, date: Date, for note: Note?) {
        if let note = note, let index = notes.firstIndex(where: { $0.id == note.id }) {
            // Update existing note
            notes[index].content = content
            notes[index].date = date
        } else {
            // Add new note
            let newNote = Note(content: content, date: date)
            notes.append(newNote)
        }
        sortAndSave()
    }
    
    func deleteNote(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }

    private func sortAndSave() {
        // Sort notes by date, newest first
        notes.sort { $0.date > $1.date }
        saveNotes()
    }
    
    private func saveNotes() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(notes)
            UserDefaults.standard.set(data, forKey: notesKey)
        } catch {
            print("Error encoding notes: \(error.localizedDescription)")
        }
    }

    private func loadNotes() {
        guard let data = UserDefaults.standard.data(forKey: notesKey) else { return }
        do {
            let decoder = JSONDecoder()
            notes = try decoder.decode([Note].self, from: data)
        } catch {
            print("Error decoding notes: \(error.localizedDescription)")
        }
    }
}
