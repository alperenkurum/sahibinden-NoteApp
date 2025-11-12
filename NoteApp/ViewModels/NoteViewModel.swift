//
//  NoteViewModel.swift
//  NoteApp
//
//  Created by Ibrahim Alperen Kurum on 17.10.2025.
//

import UIKit

class NoteViewModel {
    var filteredNotes : [Note] = []
    var notes : [Note] = []
    let noteStorage: NoteStorage = UserDefaultsNoteStorage()
    
    func isFiltering(searchController: UISearchController) -> Bool{
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    func filterContentForSearchText(_ searchText: String, in notesTableView: UITableView) {
        guard !searchText.isEmpty else {
            notesTableView.reloadData()
            return }
        filteredNotes = notes.filter { $0.title.lowercased().contains(searchText.lowercased())}
    }
    
    func addNewNote(Note note: Note){
        notes.append(note)
    }
    
    func removeNote(at index: Int){
        notes.remove(at: index)
    }
    
    func setNote(at index: Int, with note: Note){
        notes[index] = note
    }
    
    func getNoteCount(searchController: UISearchController) -> Int {
        if isFiltering(searchController: searchController) {
            return filteredNotes.count
        }
        return notes.count
    }
    
    func getNote(at index: Int, searchController: UISearchController) -> Note {
        return isFiltering(searchController: searchController) ? filteredNotes[index] : notes[index]
    }
    
//    func updateNotesInUserDefaults() {
//        do {
//            let encodedData = try JSONEncoder().encode(notes)
//            UserDefaults.standard.set(encodedData, forKey: "notes")
//            print("Notes saved")
//        } catch {
//            print("Failed to encode notes:", error)
//        }
//    }
    
    func notesCheckedSets(at index: Int, Checked isChecked: Bool, SearchController searchController: UISearchController) {
        if case isFiltering(searchController: searchController) = true{
            filteredNotes[index].check = isChecked
            if let originalIndex = notes.firstIndex(where: {$0.id == filteredNotes[index].id}){
                notes[originalIndex].check = isChecked
            }
        }else{
            notes[index].check = isChecked
        }
    }
    
    func updateDataSource(searchController: UISearchController, dataSource: UITableViewDiffableDataSource<Section, Note>?, animation: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Note>()
        snapshot.appendSections([.main])
        let noteArr = isFiltering(searchController: searchController) ? filteredNotes : notes
        snapshot.appendItems(noteArr)
        
        dataSource?.apply(snapshot, animatingDifferences: animation)
    }
 
    func fetchNotes() {
        notes = noteStorage.fetchAllNotes()
    }
    
    
}
