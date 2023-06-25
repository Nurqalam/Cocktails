//
//  LaunchScreenViewController.swift
//  Cocktails
//
//  Created by nurqalam on 26.06.2023.
//

import UIKit
import SnapKit
import Lottie

class LaunchScreenViewController: UIViewController {
    private var animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        setupAnimation()
    }

    private func setupAnimation() {
        let animationURL = URL(string: Constants.animationURLString)!

        LottieAnimation.loadedFrom(url: animationURL, closure: { [weak self] (animation) in
            self?.animationView.animation = animation
            self?.animationView.loopMode = .loop
            self?.animationView.play()
        }, animationCache: nil)
    }
}
