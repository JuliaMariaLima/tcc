//
//  ARConstructionView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class ARConstructionView: UIView {
    
    // MARK: Properties
    
    private var backButton: BackHomeView!
    
    private var addButton: AddGeometryView!
    
    private var removeButton: RemoveGeometryView!
    
    private var closeButton: CloseView!
    
    private var leaveConstructionView: LeaveConstructionView!
        
    private var loadingView: LoadView!
    
    private var feedbackView: FeedbackView!
    
    private var initializingView: InitializingConstructionView!
    
    var drawGeometryView: DrawGeometryView!

    var allArrowButtonsView: AllArrowButtonsView!
    
    var isFirst: Bool = true
    
    // MARK: Life Cicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        setUpAllArrowButtons()
        setUpBackButton()
        setUpAddButton()
        setUpRemoveButton()
        setUpCloseButton()
        setUpLeaveConstructionView()
        setUpDrawGeometryView()
        setUpLoadingView()
        setUpFeedbackView()
        setUpInitializingView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set Up
    
    private func setUpAllArrowButtons() {
        allArrowButtonsView = AllArrowButtonsView(frame: .zero)
        addSubview(allArrowButtonsView)
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
        leaveConstructionView.yesButton.addTarget(self, action: #selector(save), for: .touchDown)
        leaveConstructionView.noButton.addTarget(self, action: #selector(leave), for: .touchDown)
    }
    
    private func setUpDrawGeometryView() {
        drawGeometryView = DrawGeometryView()
        addSubview(drawGeometryView)
    }
    
    private func setUpLoadingView() {
        loadingView = LoadView()
        addSubview(loadingView)
    }
    
    private func setUpFeedbackView() {
        feedbackView = FeedbackView()
        addSubview(feedbackView)
    }
    
    private func setUpInitializingView() {
        initializingView = InitializingConstructionView()
        addSubview(initializingView)
        
        initializingView.okButton.addTarget(self, action: #selector(ok), for: .touchDown)
    }
    
    // MARK: Constraints
    
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
        
        backButton.setUpConstraints()
        addButton.setUpConstraints()
        removeButton.setUpConstraints()
        closeButton.setUpConstraints()
        
        allArrowButtonsView.setUpConstraints()
        leaveConstructionView.setUpConstraints()
        drawGeometryView.setUpConstraints()
        loadingView.setUpConstraints()
        feedbackView.setUpConstraints()
        initializingView.setUpConstraints()
    }
    
    // MARK: Actions
    
    func showFeedBackView() {
        feedbackView.isHidden = false
        feedbackView.clickFeedback()
    }
    
    func looking() {
        removeButton.isHidden = true
        closeButton.isHidden = true
        drawGeometryView.isHidden = true
        feedbackView.isHidden = true
        allArrowButtonsView.buttonsIsHidden(true)
        
        addButton.isHidden = false
        backButton.isHidden = false
    }
    
    func addingAgain() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            
            self.closeButton.isHidden = false
            self.drawGeometryView.isHidden = false
            self.drawGeometryView.retry()
        }
    }
    
    func constructing() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.addButton.isHidden = true
            
            self.backButton.isHidden = false
            self.removeButton.isHidden = false
            self.closeButton.isHidden = false
            self.allArrowButtonsView.buttonsIsHidden(false)
            if self.isFirst {
                self.isFirst = false
                self.feedbackView.isHidden = false
                self.feedbackView.swapFeedback()
            }
        }
    }
    
    func addClassifyButtonTarget(target: Any, action: Selector) {
        drawGeometryView.addButton.addTarget(target, action: action, for: .touchDown)
    }
    
    func classify() {
        drawGeometryView.isHidden = true
        closeButton.isHidden = true
        
        loadingView.isHidden = false
        
        ConstructionManager.shared.change(to: .classifying)
    }
    
    func hideFeedbackView() {
        feedbackView.isHidden = true
    }
    
    // MARK: Objc Actions
    
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
        allArrowButtonsView.buttonsIsHidden(true)
        
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
    private func save() {
        leaveConstructionView.isHidden = true
                
        ConstructionManager.shared.change(to: .saving)
        
        loadingView.isHidden = false
    }
    
    @objc
    func leave() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.leaveConstructionView.isHidden = true
            
            self.initializingView.isHidden = false
            
            ConstructionManager.shared.change(to: .initializing)
        }
    }
    
    @objc
    private func remove() {
        removeButton.isHidden = true
        closeButton.isHidden = true
        allArrowButtonsView.buttonsIsHidden(true)
        
        addButton.isHidden = false
        
        ConstructionManager.shared.change(to: .removing)
        ConstructionManager.shared.change(to: .looking)
    }
    
    @objc
    private func close() {
        looking()
        
        ConstructionManager.shared.change(to: .looking)
    }
    
    @objc
    private func ok() {
        initializingView.isHidden = true
        
        ConstructionManager.shared.change(to: .placing)
    }
}
