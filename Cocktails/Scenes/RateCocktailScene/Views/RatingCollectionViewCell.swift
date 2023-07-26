//
//  RatingCollectionViewCell.swift
//  Cocktails
//
//  Created by nurqalam on 26.07.2023.
//

import UIKit
import SnapKit

class RatingCollectionViewCell: UICollectionViewCell {
    
    private lazy var ratingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(ratingButton)
    }
    
    private func setupConstraints() {
        ratingButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with number: Int, isSelected: Bool) {
        ratingButton.setTitle("\(number)", for: .normal)
        ratingButton.backgroundColor = isSelected ? .blue : .gray
    }
}

