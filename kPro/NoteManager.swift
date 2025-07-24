//
//  NoteManager.swift
//  kPro
//
//  Created by KPLiOS on 2025/5/30.
//

import Foundation

class NoteManager {
    static let shared = NoteManager()
    
    private let userDefaults = UserDefaults.standard
    private let notesKey = "saved_notes"
    
    private init() {}
    
    // MARK: - 数据操作
    func getAllNotes() -> [Note] {
        guard let data = userDefaults.data(forKey: notesKey),
              let notes = try? JSONDecoder().decode([Note].self, from: data) else {
            return []
        }
        return notes.sorted { $0.modifiedAt > $1.modifiedAt }
    }
    
    func saveNote(_ note: Note) {
        var notes = getAllNotes()
        
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.append(note)
        }
        
        saveNotes(notes)
    }
    
    func deleteNote(withId id: UUID) {
        var notes = getAllNotes()
        notes.removeAll { $0.id == id }
        saveNotes(notes)
    }
    
    private func saveNotes(_ notes: [Note]) {
        if let data = try? JSONEncoder().encode(notes) {
            userDefaults.set(data, forKey: notesKey)
        }
    }
    
    // MARK: - 搜索功能
    func searchNotes(query: String) -> [Note] {
        let allNotes = getAllNotes()
        guard !query.isEmpty else { return allNotes }
        
        return allNotes.filter { note in
            note.title.localizedCaseInsensitiveContains(query) ||
            note.content.localizedCaseInsensitiveContains(query) ||
            note.tags.contains { $0.localizedCaseInsensitiveContains(query) }
        }
    }
    
    // MARK: - 标签功能
    func getAllTags() -> [String] {
        let allNotes = getAllNotes()
        let allTags = allNotes.flatMap { $0.tags }
        return Array(Set(allTags)).sorted()
    }
    
    func getNotesByTag(_ tag: String) -> [Note] {
        let allNotes = getAllNotes()
        return allNotes.filter { $0.tags.contains(tag) }
    }
    
    func getNotesByColor(_ color: NoteColor) -> [Note] {
        let allNotes = getAllNotes()
        return allNotes.filter { $0.color == color }
    }
} 