//
//  MainViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Lottie

class MainViewController: ThemedViewController {
    let items = [Constants.nonAlcoholicCategory, Constants.alcoholicCategory]
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    var segmentedControl: CustomSegmentedControl?
    var viewModel = DrinksViewModel()
    var selectedDrinkID: String?
    
    private let selectedIndex = BehaviorRelay<Int>(value: 0)
    private var isAnimationSetup = false
    private let disposeBag = DisposeBag()

    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        return view
    }()

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
        
        if let item = items.first {
            viewModel.fetchDrinks(for: item)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding = (layout.minimumInteritemSpacing * CGFloat(items.count - 1))
        let availableWidth = collectionView.frame.width - padding
        let cellWidth = availableWidth / CGFloat(items.count)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        if !isAnimationSetup && viewModel.isLoading.value {
            animationView.play()
            isAnimationSetup = true
        }
    }

    override func applyTheme() {
        view.backgroundColor = theme.backgroundDefault
        collectionView.backgroundColor = theme.backgroundDefault
    }
    
    private func setup() {
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
                
        observeResponse()
        setupAnimation()
        setupSegmentedControl()
        setupViews()
        setupCollectionView()
        setupSearchBar()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func observeResponse() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                self?.animationView.isHidden = !isLoading
                if isLoading {
                    self?.animationView.play()
                } else {
                    self?.animationView.stop()
                }
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(viewModel.searchText.distinctUntilChanged(), selectedIndex.asObservable())
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] searchText, selectedIndex in
                guard let self = self else { return }
                self.viewModel.fetchDrinks(for: self.items[selectedIndex], filter: searchText)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSearchBar() {
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        searchBar.rx.searchButtonClicked
            .bind { [weak self] in
                self?.searchBar.resignFirstResponder()
            }
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

    private func setupAnimation() {
        let animationURL = URL(string: Constants.animationURLString)!

        LottieAnimation.loadedFrom(url: animationURL, closure: { [weak self] (animation) in
            self?.animationView.animation = animation
            self?.animationView.loopMode = .loop
            if self?.viewModel.isLoading.value == true {
                self?.animationView.play()
            }
        }, animationCache: nil)
    }

    private func setupViews() {
        title = Constants.mainTitle
        view.backgroundColor = theme.backgroundDefault
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(animationView)

        if let segmentedControl = segmentedControl {
            view.addSubview(segmentedControl)
        }
        
        if let font = UIFont(name: Constants.aliceFont, size: CGFloat(Constants.titleSize)) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: font]
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true

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
        
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}


