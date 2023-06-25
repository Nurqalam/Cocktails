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
    
    var viewModel: DetailsViewModel?
    private var disposeBag = DisposeBag()

    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
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
        iv.image = UIImage(named: "glass")
        iv.isHidden = true
        return iv
    }()
    
    private lazy var glassLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.aliceFont, size: 16)
        label.textColor = theme.primary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var alcoholicLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.aliceFont, size: 16)
        label.textColor = .third
        label.numberOfLines = 0
        return label
    }()

    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions"
        label.font = UIFont(name: Constants.aliceFont, size: 24)
        label.textColor = theme.primary
        label.numberOfLines = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
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
        
        let glassStackView = UIStackView(arrangedSubviews: [glassLabel, alcoholicLabel])
        glassStackView.axis = .horizontal
        glassStackView.distribution = .equalCentering
        glassStackView.alignment = .fill
        glassStackView.spacing = 16
        view.addSubview(glassStackView)
        
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
