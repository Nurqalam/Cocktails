//
//  MainViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: ThemedViewController {
    let items = ["Alco", "Non-Alco"]

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private var segmentedControl: CustomSegmentedControl?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = theme.backgroundDefault
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
        
        setupSegmentedControl()
        setupViews()
    }

    private func setupSegmentedControl() {
        let segmentFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        segmentedControl = CustomSegmentedControl(frame: segmentFrame, buttonTitles: items)
        
        segmentedControl?.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                self.selectedIndex.accept(index)
            })
            .disposed(by: disposeBag)
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


