//
//  LeaveConstructionView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class LeaveConstructionView: UIView {
    private var backgroundLeaveConstruction: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    
    private var titleLabel: UILabel!
    private var explanationLabel: UILabel!
    
    var yesButton: UIButton!
    var noButton: UIButton!
    var cancelButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpCircleView()
        setUpTriangleView()
        setUpTitle()
        setUpExplanation()
        setUpYesButton()
        setUpNoButton()
        setUpCancelButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpBackground() {
        let image = UIImage(named: "backgroundLeaveConstruction")
        backgroundLeaveConstruction = UIImageView(image: image)
        backgroundLeaveConstruction.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundLeaveConstruction)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .down)
        circleView = UIImageView(image: mirrorImage)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circleView)
    }
    private func setUpTriangleView() {
        let image = UIImage(named: "triangleEndGame")
        triangleView = UIImageView(image: image)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        triangleView.transform = triangleView.transform.rotated(by: -.pi / 2)
        
        addSubview(triangleView)
    }

    private func setUpTitle() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 39)!
        titleLabel.numberOfLines = 1
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        titleLabel.text = "Time to go!"

        addSubview(titleLabel)
    }
    
    private func setUpExplanation() {
        explanationLabel = UILabel(frame: .zero)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        explanationLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        explanationLabel.numberOfLines = 3
        explanationLabel.textColor = .lightGreen
        explanationLabel.textAlignment = .center
        explanationLabel.text = "Do you want\nto save your\nprogress?"

        addSubview(explanationLabel)
    }
    
    private func setUpYesButton() {
        let image = UIImage(named: "yesButton")

        yesButton = UIButton(frame: .zero)
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.setImage(image, for: .normal)
        
        addSubview(yesButton)
    }
    
    private func setUpNoButton() {
        let image = UIImage(named: "noButton")

        noButton = UIButton(frame: .zero)
        noButton.translatesAutoresizingMaskIntoConstraints = false
        noButton.setImage(image, for: .normal)
        
        addSubview(noButton)
    }
    private func setUpCancelButton() {
        let image = UIImage(named: "cancelButton")

       cancelButton = UIButton(frame: .zero)
       cancelButton.translatesAutoresizingMaskIntoConstraints = false
       cancelButton.setImage(image, for: .normal)
       
       addSubview(cancelButton)
    }

    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The PointsView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.6177),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658)
        ])
        
        setUpBackgroundConstraints()
        setUpCircleViewConstraints(superview)
        setUpTriangleViewConstraints(superview)
        setUpTitleConstraints()
        setUpExplanationConstraints()
        setUpCancelButtonConstraints(superview)
        setUpNoButtonConstraints(superview)
        setUpYesButtonConstraints(superview)
    }
    
    private func setUpBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundLeaveConstruction.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundLeaveConstruction.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            backgroundLeaveConstruction.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundLeaveConstruction.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setUpCircleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -60),
            circleView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -1),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.rightAnchor.constraint(equalTo: self.leftAnchor, constant: 1),
            triangleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
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
            explanationLabel.bottomAnchor.constraint(equalTo: yesButton.topAnchor, constant: -20),
            explanationLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpYesButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            yesButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            yesButton.bottomAnchor.constraint(equalTo: noButton.topAnchor, constant: -10),
            yesButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            yesButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
    
    private func setUpNoButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            noButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
            noButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            noButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
    
    private func setUpCancelButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            cancelButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            cancelButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }

}
