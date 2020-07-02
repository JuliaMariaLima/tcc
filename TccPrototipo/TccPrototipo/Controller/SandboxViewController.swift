//
//  SandboxViewController.swift
//  TccPrototipo
//
//  Created by Julia Maria Santos on 28/06/20.
//  Copyright © 2020 Julia Maria Santos. All rights reserved.
//

import UIKit

class SandboxViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The collection view to show experience icons.
    var collectionView: SandboxCollectionView!
    
    var constructions: [Construction] = []
    
    var arViewController: ARViewController!
    
    override func viewWillAppear(_ animated: Bool) {
        print("appeareing???????")
        constructions = Sandbox.shared.getAll()
        collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint(type(of:self), #function)
        view.backgroundColor = .lightGreen
        navigationController?.isNavigationBarHidden = true
        
        setUpCollectionView()
        setUpBackButton()
    }
    
    func setUpCollectionView() {
        collectionView = SandboxCollectionView()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        collectionView.setUpConstraints()
    }
    
    func setUpBackButton() {
        let backButton = BackHomeView()
        view.addSubview(backButton)
        
        backButton.setUpConstraints()
        backButton.isHidden = false
        backButton.addTarget(self, action: #selector(back), for: .touchDown)
    }
    
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

extension SandboxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return constructions.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SandboxCollectionViewCell.identifier, for: indexPath) as! SandboxCollectionViewCell
        
        if indexPath.item == 0 {
            cell.icon = UIImage(named: "newConstruction")
        } else {
            cell.icon = constructions[indexPath.item - 1].image!.getImage()!
            print("======= iconeeeee")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicou em \(indexPath.item)")
        
        if indexPath.item == 0 {
            arViewController.construction = Construction()
        } else {
            arViewController.construction = constructions[indexPath.item - 1]
        }
        
        arViewController.action = .sandbox
        self.navigationController?.pushViewController(arViewController, animated: true)
    }
}

extension SandboxViewController: UICollectionViewDelegate {}
