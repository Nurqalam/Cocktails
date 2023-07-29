//
//  RateUsViewController.swift
//  Cocktails
//
//  Created by nurqalam on 26.07.2023.
//

import UIKit
import SnapKit

class RateUsViewController: UIViewController {

    // MARK: properties
    private var selectedRating: Int?

    // MARK: elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        return stackView
    }()

    private lazy var titleContainer = UIView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rate cocktail"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Help us to improve our service and we'll make our cocktails even better and better!!"
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var justView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 16
        return view
    }()

    private lazy var ratingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 50, height: 50)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    private lazy var rateDescriptionContainer = UIView()
    private lazy var rateDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "rate from 1 to 10"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .lightGray
        return label
    }()

    private lazy var likedLabel: UILabel = {
        let label = UILabel()
        label.text = "What u exactly liked"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        return label
    }()

    private lazy var chipsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        return stackView
    }()

    private lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Напишите комментарий"
        textView.textColor = .gray
        textView.backgroundColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        return textView
    }()

    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private func createSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(height)
        }
        return view
    }

    // MARK: lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCollectionView()
    }
    
    // MARK: objc methods
    @objc private func chipButtonTapped(_ sender: ChipButton) {
        sender.isSelectedChip.toggle()
    }
    
    @objc private func sendButtonTapped() {
        print("Send button tapped")
    }

    // MARK: methods
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        view.addSubview(sendButton)
        scrollView.addSubview(stackView)
        
        let spacerView1 = createSpacerView(height: 15)
        let spacerView2 = createSpacerView(height: 60)

        stackView.addArrangedSubview(titleContainer)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(justView)
        
        stackView.addArrangedSubview(ratingCollectionView)
        stackView.addArrangedSubview(rateDescriptionContainer)
        stackView.addArrangedSubview(likedLabel)
        stackView.addArrangedSubview(chipsStackView)
        stackView.addArrangedSubview(spacerView1)
        stackView.addArrangedSubview(commentTextView)
        stackView.addArrangedSubview(spacerView2)

        titleContainer.addSubview(titleLabel)
        rateDescriptionContainer.addSubview(rateDescriptionLabel)
        
        let chipTitles = ChipModel.getChipTitles()
        for index in stride(from: 0, to: chipTitles.count, by: 2) {
            let horizontalStackView = UIStackView()
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .leading
            horizontalStackView.spacing = 10
            horizontalStackView.distribution = .fillProportionally

            for offset in 0..<2 where index + offset < chipTitles.count {
                let title = chipTitles[index + offset]
                let chipButton = ChipButton()
                chipButton.setTitle(title, for: .normal)
                chipButton.addTarget(self, action: #selector(chipButtonTapped(_:)), for: .touchUpInside)
                
                let wrapperView = UIView()
                wrapperView.addSubview(chipButton)
                
                chipButton.snp.makeConstraints { make in
                    make.top.bottom.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.trailing.lessThanOrEqualToSuperview()
                    make.width.equalTo(chipButton.intrinsicContentSize.width)
                }
                
                horizontalStackView.addArrangedSubview(wrapperView)
            }

            if chipTitles.count % 2 != 0 && index == chipTitles.count - 1 {
                let spacerView = UIView()
                horizontalStackView.addArrangedSubview(spacerView)
            }
            
            chipsStackView.addArrangedSubview(horizontalStackView)
        }
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        sendButton.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            make.height.equalTo(50)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.bottom.equalToSuperview().offset(-15)
        }

        ratingCollectionView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        justView.snp.makeConstraints { make in
            make.height.equalTo(250)
            make.width.equalTo(350)
        }
        
        titleContainer.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(25)
            make.leading.equalToSuperview().offset(10)
        }
        
        rateDescriptionContainer.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        rateDescriptionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.height.equalTo(150)
        }
    }
    
    private func setupCollectionView() {
        ratingCollectionView.dataSource = self
        ratingCollectionView.delegate = self
        ratingCollectionView.register(RatingCollectionViewCell.self, forCellWithReuseIdentifier: "RatingCell")
    }
}

extension RateUsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedRating = indexPath.row + 1
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == selectedRating {
            selectedRating = nil
        }
        collectionView.reloadData()
    }
}

extension RateUsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCell", for: indexPath) as! RatingCollectionViewCell
        cell.configure(with: indexPath.row + 1, isSelected: indexPath.row + 1 == selectedRating)
        return cell
    }
}

extension RateUsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Напишите комментарий"
            textView.textColor = .lightGray
        }
    }
}
