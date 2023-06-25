//
//  ThemedViewController.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Foundation
import UIKit

class ThemedViewController: UIViewController {
    var theme = Theme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
