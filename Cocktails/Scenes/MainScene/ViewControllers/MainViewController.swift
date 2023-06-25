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
    let items = [Constants.nonAlcoholicCategory, Constants.alcoholicCategory]

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var viewModel = DrinksViewModel()
    
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    private let disposeBag = DisposeBag()
    
    private var segmentedControl: CustomSegmentedControl?

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.backgroundColor = theme.backgroundDefault
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return collectionView
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = Constants.searchBarPlaceHolder
        return bar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupSegmentedControl()
        setupCollectionView()
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

    private func setupCollectionView() {
        viewModel.drinks
            .bind(to: collectionView.rx.items(cellIdentifier: CustomCollectionViewCell.identifier, cellType: CustomCollectionViewCell.self)) { (row, drink, cell) in
                cell.layer.cornerRadius = 16
                cell.clipsToBounds = true
                cell.configure(with: drink)
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self, let cell = self.collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell else { return }
                print(indexPath.row)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        title = Constants.mainTitle
        view.backgroundColor = theme.backgroundDefault
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        if let font = UIFont(name: Constants.aliceFont, size: CGFloat(Constants.titleSize)) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: font]
        }
        navigationController?.navigationBar.prefersLargeTitles = true

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


