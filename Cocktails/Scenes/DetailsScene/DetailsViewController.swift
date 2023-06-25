//
//  DetailsViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailsViewController: ThemedViewController {
    // MARK: - Properties
    var viewModel: DetailsViewModel?
    private var disposeBag = DisposeBag()
    
    // MARK: - Outlets
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var glassContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.cover
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var alcoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = theme.cover
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var drinkNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(name: Constants.aliceFont, size: 30)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var glassImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: Constants.glassImage)
        return iv
    }()
    
    private lazy var glassLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.aliceFont, size: 16)
        label.textColor = theme.primary
        return label
    }()
    
    private lazy var alcoholicLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.aliceFont, size: 16)
        label.textColor = .third
        return label
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.instructionsText
        label.font = UIFont(name: Constants.aliceFont, size: 24)
        label.textColor = theme.primary
        return label
    }()
    
    private lazy var instructionsTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isUserInteractionEnabled = false
        textView.font = UIFont(name: Constants.aliceFont, size: 16)
        textView.backgroundColor = theme.backgroundDefault
        return textView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        backButtonSetup()
    }
    
    // MARK: - Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func backButtonSetup() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: Constants.backButton), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.backgroundColor = .backButtonBackground
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButtonItem
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.drinkDetail
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] drinkDetail in
                self?.updateUI(with: drinkDetail)
            })
            .disposed(by: disposeBag)
        
        viewModel.drinkImage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
    
    private func updateUI(with drinkDetail: DrinkDetail) {
        drinkNameLabel.text = drinkDetail.strDrink
        glassLabel.text = drinkDetail.strGlass
        alcoholicLabel.text = drinkDetail.strAlcoholic
        instructionsTextView.text = drinkDetail.strInstructions
    }
    
    private func setupUI() {
        view.backgroundColor = theme.backgroundDefault
        view.addSubview(imageView)
        view.addSubview(drinkNameLabel)
        view.addSubview(instructionsLabel)
        view.addSubview(instructionsTextView)
        
        glassContainerView.addSubview(glassImageView)
        glassContainerView.addSubview(glassLabel)
        
        glassImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        glassLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(glassImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        alcoContainerView.addSubview(alcoholicLabel)
        
        alcoholicLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        let glassStackView = UIStackView(arrangedSubviews: [glassContainerView, alcoContainerView])
        glassStackView.axis = .horizontal
        glassStackView.distribution = .equalSpacing
        glassStackView.alignment = .fill
        glassStackView.spacing = 16
        view.addSubview(glassStackView)
        
        glassContainerView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        alcoContainerView.snp.makeConstraints { make in
            make.height.equalTo(40)
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.45)
        }
        
        drinkNameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(imageView.snp.bottom).inset(16)
        }
        
        glassStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16)
        }
        
        instructionsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(glassStackView.snp.bottom).offset(36)
        }
        
        instructionsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(instructionsLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
