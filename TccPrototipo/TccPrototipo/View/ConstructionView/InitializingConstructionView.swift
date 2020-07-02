//
//  InitializingConstructionView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 01/07/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class InitializingConstructionView: UIView {
    private var backgroundInitializing: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    private var titleLabel: UILabel!
    
    var okButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = false
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpCircleView()
        setUpTriangleView()
        setUpTitle()
        setUpOKButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundInitializing")
        backgroundInitializing = UIImageView(image: image)
        backgroundInitializing.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundInitializing)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        circleView = UIImageView(image: image)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circleView)
    }
    private func setUpTriangleView() {
        let image = UIImage(named: "triangleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .downMirrored)
        triangleView = UIImageView(image: mirrorImage)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(triangleView)
    }
    
    private func setUpTitle() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        titleLabel.numberOfLines = 4
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        titleLabel.text = "First, find a\nplan where\nyou want to\nstart building!"
        
        addSubview(titleLabel)
    }
    
    private func setUpOKButton() {
        let image = UIImage(named: "okButton")
        
        okButton = UIButton()
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.setImage(image, for: .normal)
        
        addSubview(okButton)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The InitializingConstructionView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3583),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658)
        ])
        
        setUpTitleConstraints()
        setUpCircleViewConstraints(superview)
        setUpTriangleViewConstraints(superview)
        setUpOKButtonConstraints(superview)
    }
    
    private func setUpTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpCircleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            circleView.rightAnchor.constraint(equalTo: self.leftAnchor, constant: 1),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            triangleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -60),
            triangleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094),
            triangleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094)
        ])
    }
    
    private func setUpOKButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            okButton.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            okButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            okButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
}
