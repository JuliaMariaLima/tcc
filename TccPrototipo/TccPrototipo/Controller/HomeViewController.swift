//
//  HomeViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var gameViewController = GameViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGreen
        navigationController?.isNavigationBarHidden = true
        
        setUpButtons()
    }
    
    func setUpButtons() {
        let playButton = HomeButtonView(type: .play)
        view.addSubview(playButton)
        playButton.setUpConstraints()
        playButton.addTarget(self, action: #selector(play), for: .touchDown)
        
        let constructButton = HomeButtonView(type: .construct)
        view.addSubview(constructButton)
        constructButton.setUpConstraints()
        constructButton.addTarget(self, action: #selector(construct), for: .touchDown)
    }
    
    @objc
    func play() {
        print("play")
        self.navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @objc
    func construct() {
        print("construct")
        //self.navigationController?.pushViewController(ConstructViewController(), animated: true)
    }
}

