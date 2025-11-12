//
//  NewNotesViewController.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 16.09.2025.
//

import UIKit

//protocol NoteDelegate: AnyObject {
//    func didNoteAdd(note: Note)
//    func didNoteUpdate(note: Note, at indexPath: IndexPath)
//}
    
class NewNoteViewController: UIViewController {
    //weak var delegateNote: (NoteDelegate)?
    // TODO: - Computed Propertylere bak. Buradaki UIComponentleri computed variable içersinde create et.
    var showEditOrSave: Bool = false
    var noteIndexPath = IndexPath()
    var newNote:((_ note: Note) -> ())?
    var updateNote:((_ title: String, _ body: String, _ indexPath: IndexPath) -> ())?
    
    var editButton: UIBarButtonItem = {
        var eButton = UIBarButtonItem()
        eButton.title = "Not Düzenle"
        return eButton
    }()
    
    var saveButton: UIBarButtonItem = {
        var sButton = UIBarButtonItem()
        sButton.title = "Yeni Not Ekle"
        return sButton
    }()
    
    var titleTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = .systemFont(ofSize: 20, weight: .medium)
        text.borderStyle = .roundedRect
        text.placeholder = "Not Başlığı"
        return text
    }()
    
    var bodyTextView: UITextView = {
        let bTextView = UITextView()
        bTextView.translatesAutoresizingMaskIntoConstraints = false
        bTextView.font = .systemFont(ofSize: 16)
        bTextView.layer.cornerRadius = 8
        bTextView.layer.shadowColor = UIColor.black.cgColor
        bTextView.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        return bTextView
    }()
    
    var placeholderLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.text = "Not girmeye başlayabilirsiniz ..."
        tLabel.sizeToFit()
        tLabel.textColor = .tertiaryLabel
        return tLabel
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    private func configureUI(){
        view.backgroundColor = .systemBackground
        configureTitleTextField()
        configureBodyTextView()
        configurePlaceholderForBodyTextView()
        configureButton()
        setConsraints()
    }
    
    private func configureTitleTextField(){
        view.addSubview(titleTextField)
    }
    
    private func configureBodyTextView(){
        view.addSubview(bodyTextView)
        bodyTextView.delegate = self
    }
    
    private func configurePlaceholderForBodyTextView(){
        bodyTextView.addSubview(placeholderLabel)
        placeholderLabel.font = .italicSystemFont(ofSize: (bodyTextView.font?.pointSize)!)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (bodyTextView.font?.pointSize)! / 2)
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
    }

    func setConsraints(){
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),

            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            bodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        ])
    }
    
    private func configureButton(){
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTapped))
        //uiaction
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEditable))
        // TODO: make it if case
        if case showEditOrSave = true {
            title = "Not Düzenle"
            navigationItem.rightBarButtonItem = editButton
        }else{
            title = "Yeni Not Ekle"
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @objc func enableEditable(){
        titleTextField.isEnabled = true
        bodyTextView.isEditable = true
        titleTextField.isUserInteractionEnabled = true
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func saveTapped(){
        if case showEditOrSave = true{
            //delegateNote?.didNoteUpdate(note: Note(title: titleTextField.text ?? "", text: bodyTextView.text ?? ""), at: noteIndexPath)
            updateNote?(titleTextField.text ?? "", bodyTextView.text ?? "", noteIndexPath)
        }else{
            //delegateNote?.didNoteAdd(note: Note(title: titleTextField.text ?? "", text: bodyTextView.text ?? ""))
            newNote?(Note(id: UUID(), title: titleTextField.text ?? "", text: bodyTextView.text ?? ""))
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
// MARK: - UITextViewDelegate
extension NewNoteViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
    }
}
