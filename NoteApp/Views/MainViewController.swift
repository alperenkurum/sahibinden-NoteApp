//
//  MainViewController.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 16.09.2025.
//

import UIKit

final class MainViewController: UIViewController, UIGestureRecognizerDelegate {
    private var notesTableView = UITableView(frame: .zero, style: .grouped)
    private let searchController = UISearchController()
    private var refreshControl = UIRefreshControl()
    private let noteViewModel = NoteViewModel()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Note>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteViewModel.fetchNotes()
        self.hideKeyboardWhenTappedAround()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noteViewModel.updateDataSource(searchController: searchController, dataSource: dataSource)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        configureTableView()
        configureSearchController()
        configureRefreshControl()
        configureDataSource()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "Notlar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewNote))
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Başlık araması ..."
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .prominent
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureRefreshControl() {
        notesTableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }

    private func configureTableView() {
        view.addSubview(notesTableView)
        notesTableView.delegate = self
        notesTableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "NoteCell")
        notesTableView.register(NotesFooterView.self, forHeaderFooterViewReuseIdentifier: NotesFooterView.reuseIdentifier)
        notesTableView.pin(to: view)
        notesTableView.tableFooterView = UIView()
        notesTableView.keyboardDismissMode = .onDrag
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Note>(tableView: notesTableView) { tableView, indexPath, note in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as? NotesTableViewCell else {return nil}
            //let note = self.noteViewModel.getNote(at: indexPath.row, searchController: self.searchController)
            cell.set(note: note, index: indexPath.row)
            cell.delegateOnChecked = self
            return cell
        }
    }
    
    @objc private func refreshData() {
        noteViewModel.updateDataSource(searchController: searchController, dataSource: dataSource, animation: false)
        refreshControl.endRefreshing()
    }
    
    @objc private func addNewNote() {
        let newNoteVC = NewNoteViewController()
        newNoteVC.newNote = { [weak self] note in
            self?.noteViewModel.noteStorage.saveNote(note: note)
            self?.noteViewModel.notes.append(note)
            //self?.noteViewModel.fetchNotes()
            self?.noteViewModel.updateDataSource(searchController: self?.searchController ?? UISearchController(), dataSource: self?.dataSource)
            self?.notesTableView.reloadData()
        }
        navigationController?.pushViewController(newNoteVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        noteViewModel.filterContentForSearchText(searchController.searchBar.text!, in: notesTableView)
        noteViewModel.updateDataSource(searchController: searchController, dataSource: dataSource)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.notesTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
        let detailViewController = createNewNoteViewController(in: indexPath)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NotesFooterView.reuseIdentifier
        ) as? NotesFooterView else {
            return nil
        }
        let rowCount = tableView.numberOfRows(inSection: section)
        footer.configureNotesCount(noteCount: rowCount)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = deleteActionHandler(tableView, leadingSwipeActionsConfigurationForRowAt: indexPath)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    private func deleteActionHandler(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UIContextualAction{
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //noteViewModel.removeNote(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            self.noteViewModel.noteStorage.deleteNote(noteId: self.noteViewModel.notes[indexPath.row].id)
            self.noteViewModel.notes.remove(at: indexPath.row)
            self.noteViewModel.updateDataSource(searchController: self.searchController, dataSource: self.dataSource)
            tableView.reloadData()
            completionHandler(true)
        }
        deleteAction.backgroundColor = .red
        return deleteAction
    }
    
    private func createNewNoteViewController(in indexPath: IndexPath) -> NewNoteViewController {
        let selectedNote = noteViewModel.notes[indexPath.row]
        let detailViewController = NewNoteViewController()
        detailViewController.bodyTextView.text = selectedNote.text
        detailViewController.titleTextField.text = selectedNote.title
        detailViewController.bodyTextView.isEditable = false
        detailViewController.titleTextField.isUserInteractionEnabled = false
        detailViewController.showEditOrSave = true
        detailViewController.noteIndexPath = indexPath
        detailViewController.updateNote = { [weak self] title, body, indexPath in
            self?.noteViewModel.notes[indexPath.row].title = title
            self?.noteViewModel.notes[indexPath.row].text = body
            if let note = self?.noteViewModel.notes[indexPath.row]{
                self?.noteViewModel.noteStorage.updateNote(with: note)
            }
            self?.noteViewModel.updateDataSource(searchController: self?.searchController ?? UISearchController(), dataSource: self?.dataSource)
            self?.notesTableView.reloadData()
        }
        //detailViewController.delegateNote = self
        return detailViewController
    }
}

//extension MainViewController: UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return noteViewModel.getNoteCount(searchController: searchController)
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NotesTableViewCell
//        let note = noteViewModel.getNote(at: indexPath.row, searchController: searchController)
//        cell.set(note: note, index: indexPath.row)
//        //weak tekrar bak
//        //weake tekrardan baktim strong reference olanlarda weak kullanmaz isek reference edilen obje nil oldugunda strong bagli oldugu icin nill olmasina izin vermez ve obje deinit olamaz bu yuzden dolayi reference ederken weak reference yaparsak obje nilkl oldugunda reference da nil olabilir ve boylece obje deinit olabilir fakat burada oncheckdi main view controllerda weak self yapamamizin nedenini tam anlayamadim weak kalidirinca da sikintisiz tum fonksiyonlar calisiyor
//        //for protocol
//        cell.delegateOnChecked = self
//        /*Call Back
//         cell.onChecked = { [weak self] isChecked, index in
//            if case self?.isFiltering = true{
//                self?.filteredNotes[index].check = isChecked
//                if let originalIndex = self?.notes.firstIndex(where: {$0.id == self?.filteredNotes[index].id}){
//                    self?.notes[originalIndex].check = isChecked
//                }
//            }else{
//                self?.notes[index].check = isChecked
//            }
//            self?.notesTableView.reloadData()
//            self?.updateNotesInUserDefaults()
//            print(isChecked)
//            print(index)
//        }*/
//        return cell
//    }
//}

/* FOR PROTOCOL
 extension MainViewController: NoteDelegate {
    func didNoteAdd(note: Note) {
        notes.append(note)
        notesTableView.reloadData()
        updateNotesInUserDefaults()
    }
    
    func didNoteUpdate(note: Note, at indexPath: IndexPath) {
        notes[indexPath.row] = note
        notesTableView.reloadData()
        updateNotesInUserDefaults()
    }
}*/

extension MainViewController: OnCheckedDelegate {
    func onChecked(isChecked: Bool, index: Int) {
        noteViewModel.notesCheckedSets(at: index, Checked: isChecked, SearchController: searchController)
        notesTableView.reloadData()
        var note = noteViewModel.notes[index]
        note.check = isChecked
        noteViewModel.notes[index] = note
        noteViewModel.noteStorage.updateNote(with: note)
        noteViewModel.updateDataSource(searchController: searchController, dataSource: dataSource, animation: false)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        navigationController?.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
