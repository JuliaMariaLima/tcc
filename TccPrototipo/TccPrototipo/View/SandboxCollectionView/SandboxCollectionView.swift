//
//  SandboxCollectionView.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class SandboxCollectionView: UICollectionView {
    // MARK: - Properties -
    
    // MARK: - Init -
    
    /**
     A collection view with the experience icons.
     */
    convenience init() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 100, left: 20, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: 138, height: 138)
        layout.minimumLineSpacing = 48.0
        
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), collectionViewLayout: layout)
        
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(SandboxCollectionViewCell.self, forCellWithReuseIdentifier: SandboxCollectionViewCell.identifier)
    }
    
    /// This init is hidden to force the use of the convenience one.
    private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Set up the constraints in this view controller
     */
    func setUpConstraints() {
        guard let superview = self.superview else {
            fatalError("The SandboxCollectionView is not a subview of any UIView")
        }
        
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            self.heightAnchor.constraint(equalToConstant: superview.frame.size.height),
            self.widthAnchor.constraint(equalToConstant: superview.frame.size.width)
        ])
    }
}
