//
//  HomeViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGreen
        navigationController?.isNavigationBarHidden = true
        
        setUpButtons()
    }
    
    func setUpButtons() {
        let playButton = HomeButtonView(type: .play, from: self, to: GameViewController())
        view.addSubview(playButton)
        playButton.setUpConstraints()
        
        let constructButton = HomeButtonView(type: .construct, from: self, to: GameViewController())
        view.addSubview(constructButton)
        constructButton.setUpConstraints()
    }
}
