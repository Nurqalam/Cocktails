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

    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 30)) ?? CGSize.zero
        let insets = contentEdgeInsets
        return CGSize(width: labelSize.width + (insets.left + 15) + (insets.right + 15), height: 35)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 10
        backgroundColor = .lightGray
        setTitleColor(.black, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        invalidateIntrinsicContentSize()
    }
}
