//
//  FeedbackView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 29/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class FeedbackView: UIView {
    private var backgroundFeedback: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    private var titleLabel: UILabel!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpTitle()
        setUpCircleView()
        setUpTriangleView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpBackground() {
        let image = UIImage(named: "backgroundFeedback")
        backgroundFeedback = UIImageView(image: image)
        backgroundFeedback.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundFeedback)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .left)
        circleView = UIImageView(image: mirrorImage)
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
        titleLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        titleLabel.numberOfLines = 3
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        titleLabel.text = "Click on a\nplan to start\nthe construction!"
        
        addSubview(titleLabel)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The FeedbackView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: superview.frame.size.height * 0.1799),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.2084),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658)
        ])
        
        
        setUpTitleConstraints()
        setUpCircleViewConstraints(superview)
        setUpTriangleViewConstraints(superview)
    }
    
    private func setUpTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpCircleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            circleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            triangleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
            triangleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094),
            triangleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094)
        ])
    }
}
