//
//  AllArrowButtonsView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 01/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class AllArrowButtonsView: UIView {
    private var buttonUp: ArrowButtonView!
    
    private var buttonDown: ArrowButtonView!
    
    private var buttonRight: ArrowButtonView!
    
    private var buttonLeft: ArrowButtonView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        setUpButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addButtonsAction(buttonUpAction: Selector,
                          buttonDownAction: Selector,
                          buttonLeftAction: Selector,
                          buttonRightAction: Selector,
                          buttonReleasedAction: Selector,
                          target: Any) {
        
        buttonUp.addTarget(target, action: buttonUpAction, for: .touchDown)
        buttonUp.addTarget(target, action: buttonReleasedAction, for: .touchUpInside)
        
        buttonDown.addTarget(target, action: buttonDownAction, for: .touchDown)
        buttonDown.addTarget(target, action: buttonReleasedAction, for: .touchUpInside)
        
        buttonLeft.addTarget(target, action: buttonLeftAction, for: .touchDown)
        buttonLeft.addTarget(target, action: buttonReleasedAction, for: .touchUpInside)
        
        buttonRight.addTarget(target, action: buttonRightAction, for: .touchDown)
        buttonRight.addTarget(target, action: buttonReleasedAction, for: .touchUpInside)
    }
    
    func buttonsIsHidden(_ isHidden: Bool) {
        buttonUp.isHidden = isHidden
        buttonDown.isHidden = isHidden
        buttonLeft.isHidden = isHidden
        buttonRight.isHidden = isHidden
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("No superview for ARGameView at \(#function)")
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        buttonUp.setUpConstraints()
        buttonDown.setUpConstraints()
        buttonRight.setUpConstraints()
        buttonLeft.setUpConstraints()
    }
    
    private func setUpButtons() {
        buttonUp = ArrowButtonView(type: .up)
        self.addSubview(buttonUp)
        
        buttonDown = ArrowButtonView(type: .down)
        self.addSubview(buttonDown)
        
        buttonLeft = ArrowButtonView(type: .left)
        self.addSubview(buttonLeft)
        
        buttonRight = ArrowButtonView(type: .right)
        self.addSubview(buttonRight)
    }
}
