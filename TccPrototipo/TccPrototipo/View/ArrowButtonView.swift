//
//  ArrowButtonView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

enum ArrowButtonType {
    case up
    case down
    case left
    case right
}

class ArrowButtonView: UIButton {
    var type: ArrowButtonType!
    
    init(type: ArrowButtonType) {
        super.init(frame: .zero)
        
        self.type = type
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The ArrowButtonView is not a subview of any UIView")
        }
        
        let size: CGFloat = 53
        let padding: CGFloat = 20
        var rightConstant: CGFloat!
        var bottomConstant: CGFloat!
        
        switch self.type {
        case .up:
            rightConstant = size + padding
            bottomConstant = 2 * size + padding
        case .down:
            rightConstant = size + padding
            bottomConstant = padding
        case .right:
            rightConstant = padding
            bottomConstant = size + padding
        case .left:
            rightConstant = 2 * size + padding
            bottomConstant = size + padding
        default:
            fatalError("The ArrowButtonView type is not correct.")
        }

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: size),
            self.widthAnchor.constraint(equalToConstant: size),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -rightConstant),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomConstant)
        ])
        
        setUpImage()
    }
    
    func setUpImage() {
        var name: String!
        switch self.type {
        case .up:
            name = "upArrowButton"
        case .down:
            name = "downArrowButton"
        case .right:
            name = "rightArrowButton"
        case .left:
            name = "leftArrowButton"
        default:
            fatalError("The ArrowButtonView type is not correct.")
        }
        
        self.setImage(UIImage(named: name), for: .normal)
    }
}
