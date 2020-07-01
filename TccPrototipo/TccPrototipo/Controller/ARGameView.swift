//
//  ARGameView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 30/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import RealityKit
import UIKit

class ARGameView: UIView {

    var timerView: TimerView!
    
    var pointsView: PointsView!
    
    var placeBoardView: PlaceBoardView!
    
    var startGameView: StartGameView!
    
    var endGameView: EndGameView!
    
    var countDownView: CountDownView!
    
    var buttonUp: ArrowButtonView!
    
    var buttonDown: ArrowButtonView!
    
    var buttonRight: ArrowButtonView!
    
    var buttonLeft: ArrowButtonView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        setUpButtons()
        setUpTimerView()
        setUpPointsView()
        setUpCountDownView()
        setUpPlaceBoardView()
        setUpStartGameView()
        setUpEndGameView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setUpTimerView() {
        timerView = TimerView(duration: GameManager.shared.duration)
        self.addSubview(timerView)
    }
    
    private func setUpPointsView() {
        pointsView = PointsView(frame: .zero)
        self.addSubview(pointsView)
    }
    
    private func setUpCountDownView() {
        countDownView = CountDownView()
        self.addSubview(countDownView)
    }
    
    private func setUpPlaceBoardView() {
        placeBoardView = PlaceBoardView(frame: .zero)
        self.addSubview(placeBoardView)
    }
    
    private func setUpStartGameView() {
        startGameView = StartGameView(frame: .zero)
        self.addSubview(startGameView)
    }
    
    private func setUpEndGameView() {
        endGameView = EndGameView(frame: .zero)
        self.addSubview(endGameView)
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
    
    func addPlaceViewActions(placeAction: Selector, homeAction: Selector, target: Any) {
        placeBoardView.placeButton.addTarget(target, action: placeAction, for: .touchDown)
        placeBoardView.homeButton.addTarget(target, action: homeAction, for: .touchDown)
    }
    
    func addStartViewActions(startAction: Selector, homeAction: Selector, target: Any) {
        startGameView.playButton.addTarget(target, action: startAction, for: .touchDown)
        startGameView.homeButton.addTarget(target, action: homeAction, for: .touchDown)
    }
    
    func addEndViewActions(playAction: Selector, homeAction: Selector, target: Any) {
        endGameView.playButton.addTarget(target, action: playAction, for: .touchDown)
        endGameView.homeButton.addTarget(target, action: homeAction, for: .touchDown)
    }
    
    func addCountDownViewDelegate(delegate: GameDelegate?) {
        countDownView.delegate = delegate
    }
    
    func updatePoints(_ points: Int) {
       pointsView.update(points)
    }
    
    func buttonsIsHidden(_ isHidden: Bool) {
        buttonUp.isHidden = isHidden
        buttonDown.isHidden = isHidden
        buttonLeft.isHidden = isHidden
        buttonRight.isHidden = isHidden
    }
    
    func timerIsHidden(_ isHidden: Bool) {
        timerView.isHidden = isHidden
    }
    
    func countDownStart() {
        countDownView.start()
    }
    
    func pointsIsHidden(_ isHidden: Bool) {
        pointsView.isHidden = isHidden
    }
    
    func showPlaceBoardViewOnboarding() {
        placeBoardView.isHidden = false
        placeBoardView.onboarding()
    }
    
    func showPlaceBoardViewPlaceAgain() {
        placeBoardView.isHidden = false
        placeBoardView.placeAgain()
    }
    
    func showStartGameView() {
        startGameView.isHidden = false
    }
    func showEndGameView(score: Int, highScore: Int) {
        endGameView.present(score: score, highScore: highScore)
    }
    
    func hidePlaceBoardView() {
        placeBoardView.isHidden = true
    }
    
    func hideStartGameView() {
        startGameView.isHidden = true
    }
    
    func hideEndGameView() {
        endGameView.isHidden = true
    }
    
    func startTimer(_ completion: @escaping () -> Void) {
        timerView.startClock(completion: completion)
    }
    
    func restartTimer() {
        timerView.restart()
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
        
        timerView.setUpConstraints()
        pointsView.setUpConstraints()
        countDownView.setUpConstraints()
        
        placeBoardView.setUpConstraints()
        startGameView.setUpConstraints()
        endGameView.setUpConstraints()
    }
}
