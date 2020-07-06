//
//  FadeView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 05/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class FadeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.alpha = 0.7
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("No superview for FadeView at \(#function)")
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
}
