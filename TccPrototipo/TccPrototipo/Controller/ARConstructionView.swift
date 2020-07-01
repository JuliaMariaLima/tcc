//
//  ARConstructionView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class ARConstructionView: UIView {
    
    private var backButton: BackHomeView!
    
    private var addButton: AddGeometryView!
    
    private var removeButton: RemoveGeometryView!
    
    private var closeButton: CloseView!
    
    private var buttonUp: ArrowButtonView!
    
    private var buttonDown: ArrowButtonView!
    
    private var buttonRight: ArrowButtonView!
    
    private var buttonLeft: ArrowButtonView!
    
    private var leaveConstructionView: LeaveConstructionView!
    
    private var drawGeometryView: DrawGeometryView!
    
    private var loadingView: LoadView!
    
    private var feedbackView: FeedbackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        setUpArrowButtons()
        setUpBackButton()
        setUpAddButton()
        setUpRemoveButton()
        setUpCloseButton()
        setUpLeaveConstructionView()
        setUpDrawGeometryView()
        setUpLoadingView()
        setUpFeedbackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpArrowButtons() {
        buttonUp = ArrowButtonView(type: .up)
        addSubview(buttonUp)
        
        buttonDown = ArrowButtonView(type: .down)
        addSubview(buttonDown)
        
        buttonRight = ArrowButtonView(type: .right)
        addSubview(buttonRight)
        
        buttonLeft = ArrowButtonView(type: .left)
        addSubview(buttonLeft)
    }
    
    private func setUpBackButton() {
        backButton = BackHomeView()
        addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(back), for: .touchDown)
    }
    
    private func setUpAddButton() {
        addButton = AddGeometryView()
        addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(add), for: .touchDown)
    }
    
    private func setUpRemoveButton() {
        removeButton = RemoveGeometryView()
        addSubview(removeButton)
        
        removeButton.addTarget(self, action: #selector(remove), for: .touchDown)
    }
    
    private func setUpCloseButton() {
        closeButton = CloseView()
        addSubview(closeButton)
        
        closeButton.addTarget(self, action: #selector(close), for: .touchDown)
    }
    
    private func setUpLeaveConstructionView() {
        leaveConstructionView = LeaveConstructionView()
        addSubview(leaveConstructionView)
        
        leaveConstructionView.cancelButton.addTarget(self, action: #selector(cancel), for: .touchDown)
        leaveConstructionView.yesButton.addTarget(self, action: #selector(leave), for: .touchDown)
        leaveConstructionView.noButton.addTarget(self, action: #selector(leave), for: .touchDown)
    }
    
    private func setUpDrawGeometryView() {
        drawGeometryView = DrawGeometryView()
        addSubview(drawGeometryView)
        
        drawGeometryView.addButton.addTarget(self, action: #selector(classify), for: .touchDown)
    }
    
    private func setUpLoadingView() {
        loadingView = LoadView()
        addSubview(loadingView)
    }
    
    private func setUpFeedbackView() {
        feedbackView = FeedbackView()
        addSubview(feedbackView)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("No superview for ARConstructionView at \(#function)")
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
        
        backButton.setUpConstraints()
        addButton.setUpConstraints()
        removeButton.setUpConstraints()
        closeButton.setUpConstraints()
        leaveConstructionView.setUpConstraints()
        drawGeometryView.setUpConstraints()
        loadingView.setUpConstraints()
        feedbackView.setUpConstraints()
    }
    
    func arrowButtonsIsHidden(_ isHidden: Bool) {
        buttonUp.isHidden = isHidden
        buttonDown.isHidden = isHidden
        buttonLeft.isHidden = isHidden
        buttonRight.isHidden = isHidden
    }
    
    @objc
    private func add() {
        backButton.isHidden = true
        addButton.isHidden = true
        
        closeButton.isHidden = false
        drawGeometryView.isHidden = false
        drawGeometryView.start()
        
        ConstructionManager.shared.change(to: .adding)
    }
    
    @objc
    private func back() {
        backButton.isHidden = true
        addButton.isHidden = true
        closeButton.isHidden = true
        removeButton.isHidden = true
        arrowButtonsIsHidden(true)
        
        leaveConstructionView.isHidden = false
        
        ConstructionManager.shared.change(to: .leaving)
    }
    
    @objc
    private func cancel() {
        leaveConstructionView.isHidden = true
        
        backButton.isHidden = false
        addButton.isHidden = false
        
        ConstructionManager.shared.change(to: .looking)
    }
    
    @objc
    private func leave() {
        leaveConstructionView.isHidden = true
        
        ConstructionManager.shared.change(to: .initializing)
    }
    
    @objc
    private func remove() {
        removeButton.isHidden = true
        closeButton.isHidden = true
        arrowButtonsIsHidden(true)
        
        addButton.isHidden = false
        
        ConstructionManager.shared.change(to: .looking)
    }
    
    @objc
    private func close() {
        removeButton.isHidden = true
        closeButton.isHidden = true
        drawGeometryView.isHidden = true
        arrowButtonsIsHidden(true)
        
        addButton.isHidden = false
        backButton.isHidden = false
        
        ConstructionManager.shared.change(to: .looking)
    }
    
    @objc
    private func classify() {
        drawGeometryView.isHidden = true
        closeButton.isHidden = true
        
        loadingView.isHidden = false
        
        ConstructionManager.shared.change(to: .classifying)
    }
}
