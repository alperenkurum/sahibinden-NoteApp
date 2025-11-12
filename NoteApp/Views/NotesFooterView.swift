//
//  NotesFooterView.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 22.09.2025.
//

import UIKit

class NotesFooterView: UITableViewHeaderFooterView {

    static let reuseIdentifier = "NotesFooterView"
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            countLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureNotesCount(noteCount count: Int){
        countLabel.text = "Not Sayısı: \(count)"
    }

}
