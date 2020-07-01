//
//  LoadView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class LoadView: UIView {
    private var backgroundLoading: UIImageView!
    private var trianglesView: [UIImageView] = []
    private var titleLabel: UILabel!
    private var circleLoadView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isHidden = true
        self.translatesAutoresizingMaskIntoConstraints = false

        setUpCircleLoadView()
        setUpTrianglesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func rotate(view: UIView, time: TimeInterval) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: time, delay: 0.0, options: .curveLinear, animations: {
                view.transform = view.transform.rotated(by: CGFloat(-3*Float.pi))
            }, completion: { finished in
                UIView.animate(withDuration: time, delay: 0.0, options: .curveLinear, animations: {
                    view.transform = view.transform.rotated(by: CGFloat(-3*Float.pi))
                }, completion: { finished in
                    self.rotate(view: view, time: time)
                })
            })
        }
    }

    private func setUpCircleLoadView() {
        circleLoadView = UIView()
        circleLoadView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(circleLoadView)
    }
    
    private func setUpTrianglesView() {
        for _ in 0...7 {
            let image = UIImage(named: "circleLoad")
            let triangleView = UIImageView(image: image)
            triangleView.translatesAutoresizingMaskIntoConstraints = false
            
            trianglesView.append(triangleView)
            circleLoadView.addSubview(triangleView)
        }
    }
    
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The LoadView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1784),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.height * 0.1784)
        ])
        
        setUpCircleLoadViewConstraints()
        setUpTrianglesViewConstraints()
    
        rotate(view: circleLoadView, time: 3.0)
        
        for view in trianglesView {
            rotate(view: view, time: 1.5)
        }
    }
    
    private func setUpCircleLoadViewConstraints() {
        NSLayoutConstraint.activate([
            circleLoadView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            circleLoadView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleLoadView.heightAnchor.constraint(equalTo: self.heightAnchor),
            circleLoadView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setUpTrianglesViewConstraints() {
        let size: CGFloat = 28
        
        NSLayoutConstraint.activate([ // up
            trianglesView[0].centerXAnchor.constraint(equalTo: circleLoadView.centerXAnchor),
            trianglesView[0].topAnchor.constraint(equalTo: circleLoadView.topAnchor),
            trianglesView[0].heightAnchor.constraint(equalToConstant: size),
            trianglesView[0].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // down
            trianglesView[1].centerXAnchor.constraint(equalTo: circleLoadView.centerXAnchor),
            trianglesView[1].bottomAnchor.constraint(equalTo: circleLoadView.bottomAnchor),
            trianglesView[1].heightAnchor.constraint(equalToConstant: size),
            trianglesView[1].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // left
            trianglesView[2].centerYAnchor.constraint(equalTo: circleLoadView.centerYAnchor),
            trianglesView[2].leftAnchor.constraint(equalTo: circleLoadView.leftAnchor),
            trianglesView[2].heightAnchor.constraint(equalToConstant: size),
            trianglesView[2].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // right
            trianglesView[3].centerYAnchor.constraint(equalTo: circleLoadView.centerYAnchor),
            trianglesView[3].rightAnchor.constraint(equalTo: circleLoadView.rightAnchor),
            trianglesView[3].heightAnchor.constraint(equalToConstant: size),
            trianglesView[3].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // up left
            trianglesView[4].centerXAnchor.constraint(equalTo: trianglesView[2].rightAnchor),
            trianglesView[4].centerYAnchor.constraint(equalTo: trianglesView[0].bottomAnchor),
            trianglesView[4].heightAnchor.constraint(equalToConstant: size),
            trianglesView[4].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // up right
            trianglesView[5].centerXAnchor.constraint(equalTo: trianglesView[3].leftAnchor),
            trianglesView[5].centerYAnchor.constraint(equalTo: trianglesView[0].bottomAnchor),
            trianglesView[5].heightAnchor.constraint(equalToConstant: size),
            trianglesView[5].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // down right
            trianglesView[6].centerYAnchor.constraint(equalTo: trianglesView[1].topAnchor),
            trianglesView[6].centerXAnchor.constraint(equalTo: trianglesView[3].leftAnchor),
            trianglesView[6].heightAnchor.constraint(equalToConstant: size),
            trianglesView[6].widthAnchor.constraint(equalToConstant: size)
        ])
        
        NSLayoutConstraint.activate([ // down left
            trianglesView[7].centerYAnchor.constraint(equalTo: trianglesView[1].topAnchor),
            trianglesView[7].centerXAnchor.constraint(equalTo: trianglesView[2].rightAnchor),
            trianglesView[7].heightAnchor.constraint(equalToConstant: size),
            trianglesView[7].widthAnchor.constraint(equalToConstant: size)
        ])
    }
}
