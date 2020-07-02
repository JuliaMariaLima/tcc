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

    private var timerView: TimerView!
    
    private var pointsView: PointsView!
    
    private var placeBoardView: PlaceBoardView!
    
    private var startGameView: StartGameView!
    
    private var endGameView: EndGameView!
    
    private var countDownView: CountDownView!
    
    var allArrowButtonsView: AllArrowButtonsView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        
        setUpAllArrowButtonsView()
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
    
    private func setUpAllArrowButtonsView() {
        allArrowButtonsView = AllArrowButtonsView(frame: .zero)
        self.addSubview(allArrowButtonsView)
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
        
        placeBoardView.placeButton.addTarget(target, action: #selector(place), for: .touchDown)
        placeBoardView.homeButton.addTarget(target, action: #selector(goHome), for: .touchDown)

    }
    
    private func setUpStartGameView() {
        startGameView = StartGameView(frame: .zero)
        self.addSubview(startGameView)
        
        startGameView.playButton.addTarget(target, action: #selector(start), for: .touchDown)
        startGameView.homeButton.addTarget(target, action: #selector(goHome), for: .touchDown)
    }
    
    private func setUpEndGameView() {
        endGameView = EndGameView(frame: .zero)
        self.addSubview(endGameView)
        
        endGameView.playButton.addTarget(target, action: #selector(playAgain), for: .touchDown)
        endGameView.homeButton.addTarget(target, action: #selector(goHome), for: .touchDown)
    }
    
    func addCountDownViewDelegate(delegate: GameDelegate?) {
        countDownView.delegate = delegate
    }
    
    func updatePoints(_ points: Int) {
       pointsView.update(points)
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
        
        allArrowButtonsView.setUpConstraints()
        timerView.setUpConstraints()
        pointsView.setUpConstraints()
        countDownView.setUpConstraints()
        
        placeBoardView.setUpConstraints()
        startGameView.setUpConstraints()
        endGameView.setUpConstraints()
    }
    
    @objc
    private func place() {
        placeBoardView.isHidden = true
        
        GameManager.shared.change(to: .placing)
    }
    
    @objc
    private func start() {
        startGameView.isHidden = true
        
        countDownView.start()
        
        GameManager.shared.board.clearBoard()
        GameManager.shared.change(to: .counting)
    }
    
    @objc
    private func playAgain() {
        endGameView.isHidden = true
        
        countDownView.start()
        
        pointsView.update(GameManager.shared.resetPoints())
        timerView.restart()
        
        GameManager.shared.board.clearBoard()
        GameManager.shared.change(to: .counting)
    }
    
    @objc
    private func goHome() {
        startGameView.isHidden = true
        endGameView.isHidden = true
        
        placeBoardView.isHidden = false
        placeBoardView.onboarding()
                
        GameManager.shared.board.restart()
        GameManager.shared.change(to: .waiting)
    }
}
