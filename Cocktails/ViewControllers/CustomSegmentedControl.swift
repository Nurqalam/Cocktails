//
//  CustomSegmentedControl.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class CustomSegmentedControl: UIView {
    private var buttonTitles: [String] = []
    private var buttons: [UIButton] = []
    private var selectorView: UIView?
    private var buttonsContainer: UIView!
    private var selectorContainer: UIView!
        
    let selectedSegmentIndex = BehaviorRelay<Int>(value: 0)

    init(frame: CGRect, buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.clipsToBounds = true

        buttonsContainer = UIView()
        addSubview(buttonsContainer)

        selectorContainer = UIView()
        addSubview(selectorContainer)
        sendSubviewToBack(selectorContainer)
        
        buttonsContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectorContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
    }
    
    private func configureButtons() {
        buttons.removeAll()
        buttonsContainer.subviews.forEach({$0.removeFromSuperview()})

        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)
            button.backgroundColor = .clear
            buttons.append(button)
        }

        if let firstButton = buttons.first {
            firstButton.setTitleColor(.white, for: .normal)
        }

        let buttonStackView = UIStackView(arrangedSubviews: buttons)
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonsContainer.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureSelectorView() {
        let selectorWidth = frame.width / CGFloat(buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        selectorView?.layer.cornerRadius = frame.height / 2
        if let selectorView = selectorView {
            selectorContainer.addSubview(selectorView)
        }
    }

    private func updateView() {
        guard !buttonTitles.isEmpty else { return }
        configureButtons()
        configureSelectorView()
    }

    @objc private func buttonAction(sender: UIButton) {
        for (buttonIndex, button) in buttons.enumerated() {
            if button == sender {
                let selectorStartPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectorView?.frame.origin.x = selectorStartPosition
                })
                button.setTitleColor(.white, for: .normal)
                selectedSegmentIndex.accept(buttonIndex)
            } else {
            }
        }
    }
}
