//
//  BackHomeView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class BackHomeView: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.setImage(UIImage(named: "backButton")!, for: .normal)
        
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The BackHomeView is not a subview of any UIView")
        }
        
        let size: CGFloat = 61
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding)
        ])
        
    }
}
