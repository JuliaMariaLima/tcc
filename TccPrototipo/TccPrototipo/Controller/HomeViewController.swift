//
//  HomeViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 06/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    let arViewController = ARViewController()
    let sandboxViewController = SandboxViewController()
    
    override func viewDidLoad() {
        debugPrint(type(of:self), #function)
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
        arViewController.action = .game
        self.navigationController?.pushViewController(arViewController, animated: true)
    }
    
    @objc
    func construct() {
        print("construct")
        sandboxViewController.arViewController = arViewController
        self.navigationController?.pushViewController(sandboxViewController, animated: true)
    }
}

