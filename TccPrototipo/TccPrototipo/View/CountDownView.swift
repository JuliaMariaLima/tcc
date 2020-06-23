//
//  CountDownView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 23/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class CountDownView: UIView {
    private var imageView: UIImageView!
    private var images: [UIImage] = []
    
    weak var delegate: GameDelegate?
    
    init() {
        super.init(frame: .zero)
        
        self.isHidden = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        initializeImages()
        initializeImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The CountDownView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.3658),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        
        setUpImageViewConstraints()
    }
    
    func initializeImages() {
        for i in 1 ... 3 {
            let name = "count\(i)"
            
            if let image = UIImage(named: name){
                images.append(image)
            }
        }
    }
    
    func initializeImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(imageView)
    }
    
    func setUpImageViewConstraints() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    /// O total da animação dura 5,4 segundos
    func start(index: Int = 3) {
        guard index > 0 else {
            self.isHidden = true
            self.imageView.transform = self.imageView.transform.scaledBy(x: 10, y: 10)
            self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(Float.pi))
            delegate?.counted()
            return
        }
        
        self.isHidden = false
        
        imageView.image = images[index - 1]
        
        if index == 3 {
            imageView.alpha = 0
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                if index == 3 {
                    self.imageView.transform = self.imageView.transform.scaledBy(x: 0.1, y: 0.1)
                    self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(Float.pi))
                    self.imageView.alpha = 0
                }
            }, completion: {(_) in
                UIView.animate(withDuration: 0.6, animations: {
                    self.imageView.alpha = 1
                    self.imageView.transform = self.imageView.transform.scaledBy(x: 10, y: 10)
                    self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(Float.pi))
                }, completion: {(_) in
                    UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
                        self.imageView.transform = self.imageView.transform.scaledBy(x: 0.1, y: 0.1)
                        self.imageView.transform = self.imageView.transform.rotated(by: CGFloat(Float.pi))
                    }, completion: {(_) in
                        UIView.animate(withDuration: 0.2, animations: {
                            self.imageView.alpha = 0
                        }, completion: {(_) in
                            self.start(index: index - 1)
                        })
                    })
                })
            })
        }
    }
}
