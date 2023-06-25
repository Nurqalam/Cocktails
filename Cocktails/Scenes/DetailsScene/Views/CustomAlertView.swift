//
//  CustomAlertView.swift
//  Cocktails
//
//  Created by nurqalam on 25.06.2023.
//

import UIKit
import SnapKit

class CustomAlertView: ThemedView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: Constants.errorImage)
        return imageView
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = Constants.errorMessage
        return label
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = theme.primary
        button.layer.cornerRadius = 22
        button.setTitle(Constants.retryTitle, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.addSubview(imageView)
        self.addSubview(messageLabel)
        self.addSubview(retryButton)

        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(31)
            make.bottom.equalToSuperview().inset(40)
        }
    }
}
