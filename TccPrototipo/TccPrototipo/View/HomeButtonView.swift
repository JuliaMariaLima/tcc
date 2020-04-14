//
//  HomeButtonView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

enum HomeButtonType{
    case play
    case construct
}

class HomeButtonView: UIButton{
    private var type: HomeButtonType!
    private var origin: UIViewController!
    private var destination: UIViewController!
    
    init(type: HomeButtonType, from origin: UIViewController, to destination: UIViewController) {
        super.init(frame: .zero)
        
        self.type = type
        self.origin = origin
        self.destination = destination
        
        self.addTarget(self, action: #selector(clicked), for: .touchDown)
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
            fatalError("The HomeButtonView is not a subview of any UIView")
        }
        
        var heightConstant: CGFloat!
        var widthConstant: CGFloat!
        var topConstant: CGFloat!

        switch self.type {
        case .play:
            heightConstant = 0.2339
            widthConstant = 0.3433
            topConstant = 0.1679
        case .construct:
            heightConstant = 0.2829
            widthConstant = 0.3628
            topConstant = 0.4468
        default:
            fatalError("The HomeButtonView type is not correct.")
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * heightConstant),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * widthConstant),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.frame.size.height * topConstant)
        ])
        
        setUpImage()
    }
    
    func setUpImage() {
        var name: String!
        switch self.type {
        case .play:
            name = "playButton"
        case .construct:
            name = "constructButton"
        default:
            fatalError("The ButtonView type is not correct.")
        }
        
        self.setImage(UIImage(named: name), for: .normal)
    }
    
    @objc
    func clicked() {
        origin.navigationController?.pushViewController(destination, animated: true)
    }
}
