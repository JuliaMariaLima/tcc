//
//  ARTutorialGameView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 05/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit
import UIKit

class ARTutorialGameView: UIView {
    
    // MARK: Properties
    
    private enum Step: Int {
        case goal = 0
        case points = 1
        case matches = 2
        case timer = 3
        case timerPoints = 4
        case clickObject = 5
        case arrows = 6
        case moveAround = 7
        case combination = 8
        case finished = 9
    }
    
    private var current: Step! {
        didSet {
            print("handeling \(current.rawValue)")
            handle(step: current)
        }
    }
    
    private var imagesView: ImagesTutorialView!
    
    private var feedbackView: FeedbackView!
    
    private var pyramid: GeometryEntity!
    
    private var cube: GeometryEntity!
    
    var allArrowButtonsView: AllArrowButtonsView!
    
    weak var delegate: TutorialDelegate?
    
    var arView: ARView!
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        
        return recognizer
    }()
    
    // MARK: Life Cicle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapRecognizer)
                
        setUpAllArrowButtonsView()
        setUpImagesView()
        setUpFeedbackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set Up
    
    private func setUpAllArrowButtonsView() {
        allArrowButtonsView = AllArrowButtonsView(frame: .zero)
        self.addSubview(allArrowButtonsView)
    }
    
    private func setUpImagesView() {
        imagesView = ImagesTutorialView(frame: self.frame)
        addSubview(imagesView)
        
        imagesView.isHidden = false
    }
    
    private func setUpFeedbackView() {
        feedbackView = FeedbackView()
        addSubview(feedbackView)
        
        feedbackView.isHidden = false
    }
    
    // MARK: Constraints
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("No superview for ARTutorialGameView at \(#function)")
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        allArrowButtonsView.setUpConstraints()
        imagesView.setUpConstraints()
        feedbackView.setUpConstraints()

        current = Step.init(rawValue: 0)
    }
    
    // MARK: Actions
    
    private func nextStep() {
        let number = current.rawValue
        
        current = Step.init(rawValue: number + 1)!
    }
    
    private func lastStep() {
        let number = current.rawValue
        
        if number >= 1 {
            current = Step.init(rawValue: number - 1)!
        } else {
            nextStep()
        }
    }
    
    private func handle(step: Step) {
        switch step {
        case .goal:
            showGoal()
        case .points:
            showPoints()
        case .matches:
            showMatches()
        case .timer:
            showTimer()
        case .timerPoints:
            explainTimer()
        case .clickObject:
            showObject()
        case .arrows:
            showArrows()
        case .moveAround:
            moveAround()
        case .combination:
            matchObjects()
        case .finished:
            break
        }
    }
    
    private func showGoal() {
        imagesView.matchesTutorialHighlight.isHidden = true
        imagesView.timerTutorialHighlight.isHidden = true
        imagesView.pointsTutorialHighlight.isHidden = true
        
        feedbackView.set(text: "The goal of the game is to match similar base objects!")
    }
    
    private func showPoints() {
        imagesView.matchesTutorialHighlight.isHidden = true
        imagesView.timerTutorialHighlight.isHidden = true
        
        imagesView.pointsTutorialHighlight.isHidden = false
        feedbackView.set(text: "This is the point display.")
    }
    
    private func showMatches() {
        imagesView.pointsTutorialHighlight.isHidden = true
        imagesView.timerTutorialHighlight.isHidden = true
        
        imagesView.matchesTutorialHighlight.isHidden = false
        feedbackView.set(text: "This is how many matches you need to go to next level.")
    }
    
    private func showTimer() {
        imagesView.matchesTutorialHighlight.isHidden = true
        imagesView.pointsTutorialHighlight.isHidden = true
        
        imagesView.timerTutorialHighlight.isHidden = false
        feedbackView.set(text: "This is the time left for you to go to next level.")
    }
    
    private func explainTimer() {
        imagesView.matchesTutorialHighlight.isHidden = true
        imagesView.pointsTutorialHighlight.isHidden = true
        
        imagesView.timerTutorialHighlight.isHidden = false
        feedbackView.set(text: "Faster you go more points you accumulate!")
    }
    
    private func showObject() {
        imagesView.isHidden = true

        pyramid = delegate?.showObject(type: .QuadrilateralPyramid)
        
        feedbackView.set(text: "This is one of the objects. Click on it.")
    }
    
    private func showArrows() {
        allArrowButtonsView.buttonsIsHidden(false)
        
        feedbackView.set(text: "The arrows show the direction the buttons take them.")
    }
    
    private func moveAround() {
        feedbackView.set(text: "Move around the object to see how the arrows move.")
    }
    
    private func matchObjects() {
        cube = delegate?.showObjectUnder(object: pyramid, type: .Cube)
        
        feedbackView.set(text: "To match two objects puts them on top of each other.")
    }
    
    func finished() {
        pyramid.removeFromParent()
        cube.removeFromParent()
    }
    
    // MARK: Objc Actions
    
    @objc
    private func handleTap(recognizer: UITapGestureRecognizer) {
        var function: () -> Void
        let middle = self.frame.width / 2
        let location = recognizer.location(in: arView)

        if location.x < middle {
            function = lastStep
        } else {
            function = nextStep
        }
        
        switch current {
        case .goal, .points, .matches,.timer, .timerPoints:
            function()
        case .clickObject:
            handleClickObject(location: location, function: nextStep)
        case .arrows, .moveAround:
            nextStep()
        default:
            break
        }
    }
    
    func handleClickObject(location: CGPoint, function: () -> Void) {
        let hits = arView.hitTest(location)
        
        for hit in hits {
            if hit.entity == pyramid {
                delegate?.showOrientedEntity(for: pyramid)
                function()
            }
        }
    }
}
