//
//  ImagesTutorialView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 05/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class ImagesTutorialView: UIView {
    lazy var pointsTutorialImageView: UIImageView! = {
        let image = UIImage(named: "pointsViewTutorial")
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var pointsTutorialHighlight: UIImageView! = {
        let image = UIImage(named: "pointsTutorial")
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    }()
    
    lazy var matchesTutorialHighlight: UIImageView! = {
        let image = UIImage(named: "matchesTutorial")
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    }()
    
    lazy var timerTutorialImageView: UIImageView! = {
        let image = UIImage(named: "timerViewTutorial")
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    lazy var timerTutorialHighlight: UIImageView! = {
        let image = UIImage(named: "timerTutorial")
        let img = UIImageView(image: image)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    }()
    
    private var fadeView: FadeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pointsTutorialImageView)
        addSubview(timerTutorialImageView)
        setUpFadeView()
        addSubview(pointsTutorialHighlight)
        addSubview(matchesTutorialHighlight)
        addSubview(timerTutorialHighlight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpFadeView() {
        fadeView = FadeView(frame: self.frame)
        self.addSubview(fadeView)
    }
    
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("No superview for ImagesTutorialView at \(#function)")
        }
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        fadeView.setUpConstraints()
        
        setUpPointsViewConstraints()
        setUpTimerViewContraints()
        setUpHighlightsConstraints()
    }
    
    func setUpPointsViewConstraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            pointsTutorialImageView.heightAnchor.constraint(equalToConstant: 100),
            pointsTutorialImageView.widthAnchor.constraint(equalToConstant: 111),
            pointsTutorialImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: padding),
            pointsTutorialImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding)
        ])
    }
    
    func setUpTimerViewContraints() {
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            timerTutorialImageView.heightAnchor.constraint(equalToConstant: 62),
            timerTutorialImageView.widthAnchor.constraint(equalToConstant: 111),
            timerTutorialImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding),
            timerTutorialImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: padding)
        ])
    }
    
    func setUpHighlightsConstraints() {
        NSLayoutConstraint.activate([
            pointsTutorialHighlight.heightAnchor.constraint(equalToConstant: 45),
            pointsTutorialHighlight.widthAnchor.constraint(equalToConstant: 100),
            matchesTutorialHighlight.heightAnchor.constraint(equalToConstant: 45),
            matchesTutorialHighlight.widthAnchor.constraint(equalToConstant: 100),
            timerTutorialHighlight.heightAnchor.constraint(equalToConstant: 45),
            timerTutorialHighlight.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            pointsTutorialHighlight.centerXAnchor.constraint(equalTo: pointsTutorialImageView.centerXAnchor),
            pointsTutorialHighlight.topAnchor.constraint(equalTo: pointsTutorialImageView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            matchesTutorialHighlight.centerXAnchor.constraint(equalTo: pointsTutorialImageView.centerXAnchor),
            matchesTutorialHighlight.bottomAnchor.constraint(equalTo: pointsTutorialImageView.bottomAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            timerTutorialHighlight.centerXAnchor.constraint(equalTo: timerTutorialImageView.centerXAnchor),
            timerTutorialHighlight.centerYAnchor.constraint(equalTo: timerTutorialImageView.centerYAnchor)
        ])
    }
}
