//
//  UIViewExtension.swift
//  Whats_App
//
//  Created by Ibrahim Alperen Kurum on 16.09.2025.
//

import UIKit

extension UIView {
    //pinnnig all the stuff to edges
    func pin(to superView: UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}
