//
//  TimerView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 13/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class TimerView: UIView {
    private var labelTimer: UILabel!
    private var backgroundTimer: UIImageView!
    private var timer: Timer?
    private var duration: Int! //seconds
    private var currentTime: Int!
    
    init(frame: CGRect, duration: Int) {
        super.init(frame: frame)
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.duration = duration
        self.currentTime = self.duration

        setUpBackground()
        setUpLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLabel() {
        labelTimer = UILabel(frame: .zero)
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.font = UIFont(name: "ChalkboardSE-Regular", size: 30)!
        labelTimer.numberOfLines = 1
        labelTimer.textColor = .labelYellow
        labelTimer.textAlignment = .center
        
        addSubview(labelTimer)
        
        updateLabel()
    }
    
    private func setUpBackground() {
        let image = UIImage(named: "backgroundTimer")
        backgroundTimer = UIImageView(image: image)
        backgroundTimer.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundTimer)
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The TimerView is not a subview of any UIView")
        }
        
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 62),
            self.widthAnchor.constraint(equalToConstant: 96),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -padding),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: padding)
        ])
                
        setUpBackgroundConstraints()
        setUpLabelConstraints()
    }
    
    private func setUpBackgroundConstraints() {
        NSLayoutConstraint.activate([
            backgroundTimer.heightAnchor.constraint(equalTo: self.heightAnchor),
            backgroundTimer.widthAnchor.constraint(equalTo: self.widthAnchor),
            backgroundTimer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backgroundTimer.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setUpLabelConstraints() {
        NSLayoutConstraint.activate([
            labelTimer.heightAnchor.constraint(equalTo: self.heightAnchor),
            labelTimer.widthAnchor.constraint(equalTo: self.widthAnchor),
            labelTimer.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            labelTimer.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func clockUpdate(_ completion: @escaping () -> Void) {
        updateLabel()
        
        currentTime -= 1
        
        if(currentTime <= -1){
            timer!.invalidate()
            completion()
        }
    }
    
    private func updateLabel() {
        let seconds: Int = currentTime % 60
        let minutes: Int = (currentTime / 60) % 60
        
        labelTimer.text = String(format: "%.2d", minutes) + ":" + String(format: "%.2d", seconds)
    }
    
    func startClock(completion: @escaping () -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self](timer) in
            self!.clockUpdate(completion)
        })
        
        timer!.fire()
    }
    
    func restart() {
        self.timer?.invalidate()
        
        self.currentTime = self.duration
        
        updateLabel()
    }
}
