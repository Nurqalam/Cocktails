//
//  CustomCollectionViewCell.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import Kingfisher

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    var drinkIdCell = ""
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: Constants.aliceFont, size: CGFloat(Constants.mediumSize))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        imageView.frame = contentView.bounds
        label.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with drink: Drink) {
        label.text = drink.strDrink
        if let url = URL(string: drink.strDrinkThumb) {
            imageView.kf.setImage(with: url)
        }
        self.drinkIdCell = drink.idDrink
    }
}
