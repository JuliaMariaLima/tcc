//
//  LevelUpView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 04/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class LevelUpView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        image = UIImage(named: "levelUp")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
                
            }, completion: {(_) in
                UIView.animate(withDuration: 0.3, delay: 0.4, animations: {
                    self.alpha = 0
                })
            })
        }
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The LevelUpView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
    }
}
