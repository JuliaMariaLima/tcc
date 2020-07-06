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
    private var labelMatches: UILabel!
    private var backgroundPoints: UIImageView!
    private var points: Int! = 0 {
        didSet {
            guard let points = points else { return }
            labelPoints.text = "\(points)pts"
        }
    }
    
    private var matches: Int! = 0
    private var matchesNeeded: Int! = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setUpBackground()
        setUpLabelPoints()
        setUpLabelMatches()
        updateMatches()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundPoints")
        backgroundPoints = UIImageView(image: image)
        backgroundPoints.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundPoints)
    }
    
    private func setUpLabelPoints() {
        labelPoints = UILabel(frame: .zero)
        labelPoints.translatesAutoresizingMaskIntoConstraints = false
        labelPoints.font = UIFont(name: "ChalkboardSE-Regular", size: 30)!
        labelPoints.text = "0pts"
        labelPoints.numberOfLines = 1
        labelPoints.textColor = .triangleYellow
        labelPoints.textAlignment = .center
        
        addSubview(labelPoints)
    }
    
    private func setUpLabelMatches() {
        labelMatches = UILabel(frame: .zero)
        labelMatches.translatesAutoresizingMaskIntoConstraints = false
        labelMatches.font = UIFont(name: "ChalkboardSE-Regular", size: 30)!
        labelMatches.text = "0/1"
        labelMatches.numberOfLines = 1
        labelMatches.textColor = .triangleYellow
        labelMatches.textAlignment = .center
        
        addSubview(labelMatches)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The PointsView is not a subview of any UIView")
        }
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 100),
            self.widthAnchor.constraint(equalToConstant: 111),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding)
        ])
        
        setUpBackgroundConstraints()
        setUpLabelConstraints()
    }
    
    private func setUpBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundPoints.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundPoints.widthAnchor.constraint(equalTo: self.widthAnchor),
            backgroundPoints.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundPoints.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setUpLabelConstraints() {
        NSLayoutConstraint.activate([
            labelPoints.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelPoints.topAnchor.constraint(equalTo: self.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            labelMatches.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelMatches.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    func update(_ points: Int, isRestart: Bool) {
        self.points = points
        debugPrint(type(of:self), #function)

        if isRestart {
            matches = 0
            matchesNeeded = 1
        } else {
            matches += 1
        }
        
        updateMatches()
    }
    
    private func updateMatches() {
        labelMatches.text = "\(matches!)/\(matchesNeeded!)"
    }
    
    func sum(_ points: Int) {
        debugPrint(type(of:self), #function)
        self.points += points
        matchesNeeded += 1
        matches = 0
        
        updateMatches()
    }
}
