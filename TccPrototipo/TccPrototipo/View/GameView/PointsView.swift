//
//  PointsView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 13/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class PointsView: UIView {
    private var labelPoints: UILabel!
    private var backgroundPoints: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpBackground() {
        let image = UIImage(named: "backgroundTimer")
        backgroundPoints = UIImageView(image: image)
        backgroundPoints.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundPoints)
    }
    
    func setUpLabel() {
        labelPoints = UILabel(frame: .zero)
        labelPoints.translatesAutoresizingMaskIntoConstraints = false
        labelPoints.font = UIFont(name: "ChalkboardSE-Regular", size: 30)!
        labelPoints.text = "0pts"
        labelPoints.numberOfLines = 1
        labelPoints.textColor = .labelYellow
        labelPoints.textAlignment = .center
        
        addSubview(labelPoints)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The PointsView is not a subview of any UIView")
        }
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 62),
            self.widthAnchor.constraint(equalToConstant: 96),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding)
        ])
        
        setUpBackgroundConstraints()
        setUpLabelConstraints()
    }
    
    func setUpBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundPoints.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundPoints.widthAnchor.constraint(equalTo: self.widthAnchor),
            backgroundPoints.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundPoints.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setUpLabelConstraints() {
        NSLayoutConstraint.activate([
            labelPoints.heightAnchor.constraint(equalTo: self.heightAnchor),
            labelPoints.widthAnchor.constraint(equalTo: self.widthAnchor),
            labelPoints.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelPoints.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func update(_ points: Int) {
        labelPoints.text = "\(points)pts"
    }
}
