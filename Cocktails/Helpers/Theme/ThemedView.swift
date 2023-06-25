//
//  ThemedView.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Foundation
import UIKit

class ThemedView: UIView {
    var theme = Theme()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTheme()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTheme()
    }
    
    private func setupTheme() {
        applyTheme()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard #available(iOS 12.0, *), traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle else {
            return
        }

        refreshTheme()
    }
    
    @objc private func refreshTheme() {
        theme = Theme()
        applyTheme()
    }
    
    func applyTheme() {
    }
}
