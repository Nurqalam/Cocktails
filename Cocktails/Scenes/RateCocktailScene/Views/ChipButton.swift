//
//  ChipButton.swift
//  Cocktails
//
//  Created by nurqalam on 26.07.2023.
//

import UIKit

class ChipButton: UIButton {

    var isSelectedChip: Bool = false {
        didSet {
            backgroundColor = isSelectedChip ? .blue : .lightGray
            setTitleColor(isSelectedChip ? .white : .black, for: .normal)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 10
        backgroundColor = .lightGray
        setTitleColor(.black, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
