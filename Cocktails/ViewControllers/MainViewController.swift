//
//  MainViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit

class MainViewController: UIViewController {

    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return collectionView
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        title = "Cocktails"
        
        setupViews()
    }

    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
}


