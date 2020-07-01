//
//  DrawGeometryView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class DrawGeometryView: UIView {
    private var backgroundDrawGeometry: UIImageView!
    private var circleView: UIImageView!
    private var triangleView: UIImageView!
    private var titleLabel: UILabel!
    private var canvas: Canvas!
    
    var addButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpTitle()
        setUpCanvas()
        setUpAddButton()
        setUpCircleView()
        setUpTriangleView()
        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func retry() {
        canvas.clear()
        titleLabel.text = "Not a match :(\nDraw again!"
    }
    
    func start() {
        canvas.clear()
        titleLabel.text = "Draw the form\nthat you want!"
    }
    
    private func setUpCanvas() {
        canvas = Canvas()
        
        addSubview(canvas)
    }
    
    private func setUpAddButton() {
        let image = UIImage(named: "addButton")
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(image, for: .normal)
        
        addSubview(addButton)
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundLeaveConstruction")
        backgroundDrawGeometry = UIImageView(image: image)
        backgroundDrawGeometry.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundDrawGeometry)
    }
    
    private func setUpCircleView() {
        let image = UIImage(named: "circleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .upMirrored)
        circleView = UIImageView(image: mirrorImage)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circleView)
    }
    private func setUpTriangleView() {
        let image = UIImage(named: "triangleEndGame")
        let mirrorImage = UIImage(cgImage: (image?.cgImage)!, scale: 1, orientation: .upMirrored)
        triangleView = UIImageView(image: mirrorImage)
        triangleView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(triangleView)
    }
    
    private func setUpTitle() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "ChalkboardSE-Light", size: 26)!
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .lightGreen
        titleLabel.textAlignment = .center
        
        addSubview(titleLabel)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The DrawGeometryView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.6177),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658)
        ])
        
        canvas.setUpConstraints()
        
        setUpTitleConstraints()
        setUpAddButtonConstraints(superview)
        setUpCircleViewConstraints(superview)
        setUpTriangleViewConstraints(superview)
    }
    
    private func setUpTitleConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }
    
    private func setUpAddButtonConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            addButton.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0873),
            addButton.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1994)
        ])
    }
    
    private func setUpCircleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 60),
            circleView.leftAnchor.constraint(equalTo: self.rightAnchor, constant: -1),
            circleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1514),
            circleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.0959)
        ])
    }
    
    private func setUpTriangleViewConstraints(_ superview: UIView) {
        NSLayoutConstraint.activate([
            triangleView.bottomAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            triangleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            triangleView.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094),
            triangleView.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1094)
        ])
    }
}
