//
//  SandboxCollectionViewCell.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class SandboxCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties -
        
    /// Returns an unique identifier for a collection reusable view
    static var identifier: String {
        return String(describing: self)
    }
    
    // MARK: Subviews
    
    /// The image view for the icon of the construction.
    private var imageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 70
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.0
        view.contentMode = .scaleAspectFill
        
        // FIXME: Remove color
//         view.backgroundColor = .borderRed
        return view
    }()
    
    /// Use this property to set the cell icon.
    var icon: UIImage! {
        get {
            return imageView.image
        } set {
            imageView.image = newValue
        }
    }
    
    // MARK: - Init -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentMode = .scaleAspectFill
        
        setupViews()
        addShadow()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods -
    
    // MARK: Setup methods
    
    /// Add subviews and setup their constraints
    private func setupViews() {
        contentView.addSubview(imageView)
        imageView.frame.size = contentView.bounds.size
    }

    /// Adds a shadow to the background of the cell
    private func addShadow() {
        
        let generalOffset: CGFloat = 2.5
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: generalOffset, height: generalOffset)
        self.layer.shadowRadius = generalOffset
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: self.imageView.layer.cornerRadius).cgPath
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 138.0),
            self.widthAnchor.constraint(equalToConstant: 138.0),
        ])
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 138.0),
            imageView.widthAnchor.constraint(equalToConstant: 138.0),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
