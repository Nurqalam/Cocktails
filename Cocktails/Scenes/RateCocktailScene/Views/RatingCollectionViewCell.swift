//
//  RatingCollectionViewCell.swift
//  Cocktails
//
//  Created by nurqalam on 26.07.2023.
//

import UIKit
import SnapKit

class RatingCollectionViewCell: UICollectionViewCell {
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.layer.cornerRadius = 25
        label.clipsToBounds = true
        return label
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
        contentView.addSubview(ratingLabel)
        contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 25
    }
    
    private func setupConstraints() {
        ratingLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with number: Int, isSelected: Bool) {
        ratingLabel.text = "\(number)"
        contentView.backgroundColor = isSelected ? .blue : .lightGray
    }
}
