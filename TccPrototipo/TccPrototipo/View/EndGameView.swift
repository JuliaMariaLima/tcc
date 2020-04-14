//
//  EndGameView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 13/04/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class EndGameView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func present() {
        print("ACABOUUUUU O PROGRAMA")
    }
}
