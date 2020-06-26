//
//  PlaceBoardView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 22/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class PlaceBoardView: UIView {
    private var backgroundEndGame: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    
    private var titleLabel: UILabel!
    private var explanationLabel: UILabel!
    
    var placeButton: UIButton!
    var homeButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpCircleView()
        setUpTriangleView()
        setUpTitle()
        setUpExplanation()
        setUpPlaceButton()
        setUpHomeButton()
        onboarding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onboarding() {
        titleLabel.text = "Onboarding!"
        explanationLabel.text = "Choose 4 points\nto delimit the\nboard space"
    }
    
    func placeAgain() {
        titleLabel.text = "Place Again!"
        explanationLabel.text = "Please, choose\na bigger space\nto start playing"
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundEndGame")
        backgroundEndGame = UIImageView(image: image)
        backgroundEndGame.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundEndGame)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .downMirrored)
        circleView = UIImageView(image: mirrorImage)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.transform = circleView.transform.rotated(by: .pi / 2)
        
        addSubview(circleView)
    }
    private func setUpTriangleView() {
        let image = UIImage(named: "triangleEndGame")
        triangleView = UIImageView(image: image)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        triangleView.transform = triangleView.transform.rotated(by: .pi / 2)
        
        addSubview(triangleView)
    }

    private func setUpTitle() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 39)!
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    private func setUpExplanation() {
        explanationLabel = UILabel(frame: .zero)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        explanationLabel.numberOfLines = 3
        explanationLabel.textColor = .lightGreen
        explanationLabel.textAlignment = .center
        
        addSubview(explanationLabel)
    }
    
    private func setUpPlaceButton() {
        let image = UIImage(named: "placeButton")

        placeButton = UIButton(frame: .zero)
        placeButton.translatesAutoresizingMaskIntoConstraints = false
        placeButton.setImage(image, for: .normal)
        
        addSubview(placeButton)
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
        setUpExplanationConstraints()
        setUpHomeButtonConstraints(superview)
        setUpPlaceButtonConstraints(superview)
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
            circleView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60),
            triangleView.leftAnchor.constraint(equalTo: self.rightAnchor),
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
    
    private func setUpExplanationConstraints() {
        NSLayoutConstraint.activate([
            explanationLabel.bottomAnchor.constraint(equalTo: placeButton.topAnchor, constant: -20),
            explanationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpPlaceButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            placeButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeButton.bottomAnchor.constraint(equalTo: homeButton.topAnchor, constant: -10),
            placeButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            placeButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
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
    
}
