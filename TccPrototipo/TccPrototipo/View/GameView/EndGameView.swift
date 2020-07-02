//
//  EndGameView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 13/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class EndGameView: UIView {
    private var backgroundEndGame: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    
    private var titleLabel: UILabel!
    private var scoreLabel: UILabel!
    private var highScoreLabel: UILabel!
    
    var playButton: UIButton!
    var homeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpCircleView()
        setUpTriangleView()
        setUpTitle()
        setUpScore()
        setUpHighScore()
        setUpPlayButton()
        setUpHomeButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundEndGame")
        backgroundEndGame = UIImageView(image: image)
        backgroundEndGame.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundEndGame)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        circleView = UIImageView(image: image)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circleView)
    }
    private func setUpTriangleView() {
        let image = UIImage(named: "triangleEndGame")
        triangleView = UIImageView(image: image)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(triangleView)
    }

    private func setUpTitle() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 39)!
        titleLabel.text = "Time is over!"
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    private func setUpScore() {
        scoreLabel = UILabel(frame: .zero)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        scoreLabel.text = "Score: "
        scoreLabel.numberOfLines = 1
        scoreLabel.textColor = .lightGreen
        scoreLabel.textAlignment = .center
        
        addSubview(scoreLabel)
    }
    private func setUpHighScore() {
        highScoreLabel = UILabel(frame: .zero)
        highScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        highScoreLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        highScoreLabel.text = "High Score: "
        highScoreLabel.numberOfLines = 1
        highScoreLabel.textColor = .lightGreen
        highScoreLabel.textAlignment = .center
        
        addSubview(highScoreLabel)
    }
    
    private func setUpPlayButton() {
        let image = UIImage(named: "playEndGame")

        playButton = UIButton(frame: .zero)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(image, for: .normal)
        
        addSubview(playButton)
    }
    private func setUpHomeButton() {
        let image = UIImage(named: "homeEndGame")

       homeButton = UIButton(frame: .zero)
       homeButton.translatesAutoresizingMaskIntoConstraints = false
       homeButton.setImage(image, for: .normal)
       
       addSubview(homeButton)
    }

    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The PointsView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.5592),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658)
        ])
        
        setUpBackgroundConstraints()
        setUpCircleViewConstraints(superview)
        setUpTriangleViewConstraints(superview)
        setUpTitleConstraints()
        setUpHighScoreConstraints()
        setUpScoreConstraints()
        setUpHomeButtonConstraints(superview)
        setUpPlayButtonConstraints(superview)
    }
    
    private func setUpBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundEndGame.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundEndGame.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundEndGame.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundEndGame.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setUpCircleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            circleView.rightAnchor.constraint(equalTo: self.leftAnchor),
            circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15),
            triangleView.bottomAnchor.constraint(equalTo: self.topAnchor),
            triangleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094),
            triangleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094)
        ])
    }

    private func setUpTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpScoreConstraints() {
        NSLayoutConstraint.activate([
            scoreLabel.bottomAnchor.constraint(equalTo: highScoreLabel.topAnchor, constant: -10),
            scoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    private func setUpHighScoreConstraints() {
        NSLayoutConstraint.activate([
            highScoreLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
            highScoreLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpPlayButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -10),
            playButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            playButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
    
    private func setUpHomeButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            homeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            homeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            homeButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            homeButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
    
    func present(score: Int? = 0, highScore: Int? = 0) {
        print("ACABOUUUUU O PROGRAMA")
        scoreLabel.text = "Score: \(score ?? 0)"
        highScoreLabel.text = "High Score: \(highScore ?? 0)"
        
        self.isHidden = false
    }
}
