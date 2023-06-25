//
//  Theme.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import Foundation
import UIKit

class Theme {
    enum Mode {
        case light, dark
    }

    var currentMode: Mode {
        return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }

    var backgroundDefault: UIColor {
        switch currentMode {
        case .light:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .dark:
            return UIColor(red: 0.084, green: 0.084, blue: 0.084, alpha: 1)
        }
    }

    var primary: UIColor {
        switch currentMode {
        case .light:
            return UIColor(red: 0.961, green: 0.737, blue: 0.075, alpha: 1)
        case .dark:
            return UIColor(red: 0.925, green: 0.745, blue: 0.263, alpha: 1)
        }
    }
    
    var cover: UIColor {
        switch currentMode {
        case .light:
            return UIColor(red: 0.961, green: 0.961, blue: 0.961, alpha: 1)
        case .dark:
            return UIColor(red: 0.129, green: 0.129, blue: 0.129, alpha: 1)
        }
    }
}
