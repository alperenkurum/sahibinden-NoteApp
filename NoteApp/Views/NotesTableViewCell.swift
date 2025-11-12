//
//  NotesTableViewCell.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 16.09.2025.
//

import UIKit
protocol OnCheckedDelegate: AnyObject {
    func onChecked(isChecked: Bool, index: Int)
}

class NotesTableViewCell: UITableViewCell {
    weak var delegateOnChecked: OnCheckedDelegate?
    private var noteTitle = UILabel()
    private var noteText = UILabel()
    private var stackView = UIStackView()
    private var isChecked = false
    private var button = UIButton()
    private var outerStackView = UIStackView()
    private var buttonStackView = UIStackView()
    private var index: Int?
    //var onChecked:((_ isChecked: Bool, _ index: Int) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        configureUILabels()
        configureStackView()
        configureButton()
        configureOuterStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(note: Note, index: Int) {
        noteTitle.text = note.title
        noteText.text = note.text
        isChecked = note.check
        button.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
        self.index = index
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(noteTitle)
        stackView.addArrangedSubview(noteText)
    }
    
    private func configureUILabels() {
        noteTitle.numberOfLines = 1
        noteTitle.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        noteText.numberOfLines = 1
        noteText.font = UIFont.systemFont(ofSize: 12, weight: .light)
        noteText.textColor = UIColor.gray
    }
    
    private func configureButton() {
        //contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 8
        // burada retain cycle oluyor mu mainVC -> TableView-> cell -> button -> MainVC
        let action = UIAction{[weak self] _ in
            self?.buttonTapped()
        }
        //button.addTarget(self, action: #selector(handleCheckmarkButtonTapped), for: .touchUpInside)
        button.addAction(action, for: .primaryActionTriggered)
    }
    
    private func buttonTapped() {
        isChecked = !isChecked
        //button.backgroundColor = isChecked ? .red : .green
        button.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
        //isChecked.toggle()
        guard let index = index else { return }
        delegateOnChecked?.onChecked(isChecked: isChecked, index: index)
    }
    
    private func configureOuterStackView() {
        contentView.addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.axis = .horizontal
        outerStackView.spacing = 12
        outerStackView.layer.cornerRadius = 8
        outerStackView.clipsToBounds = true
        outerStackView.distribution = .fill
        outerStackView.alignment = .leading
        outerStackView.addArrangedSubview(stackView)
        outerStackView.addArrangedSubview(button)
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
//    @objc private func handleCheckmarkButtonTapped() {
//        isChecked = !isChecked
//        //button.backgroundColor = isChecked ? .red : .green
//        button.setImage(UIImage(systemName: isChecked ? "checkmark.circle.fill" : "circle"), for: .normal)
//        //isChecked.toggle()
//        guard let index = index else { return }
//        delegateOnChecked?.onChecked(isChecked: isChecked, index: index)
//    }
}
