//
//  MainViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    private let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var segmentedControl: CustomSegmentedControl?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return collectionView
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
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
        
        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        segmentedControl?.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl?.snp.bottom ?? searchBar.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
        }
    }
}


