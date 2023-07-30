//
//  SpeedometerView.swift
//  Cocktails
//
//  Created by nurqalam on 30.07.2023.
//

import UIKit

class SpeedometerView: UIView {
    var selectedValue: CGFloat = 5 {
        didSet {
            bigLabel.text = "\(Int(selectedValue))"
            updateView()
        }
    }

    private var arrowLayer: CAShapeLayer!
    private var progressBarLayer: CAShapeLayer!
    private var progressBarBackgroundLayer: CAShapeLayer!
    private var protractorLayers: [CALayer] = []

    private let bigLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 48)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addLabels()
        bigLabel.frame = CGRect(x: 0, y: bounds.midY + 60, width: bounds.width, height: 50)
        drawProtractor()
        updateView()
    }

    private func setupView() {
        bigLabel.text = "\(Int(selectedValue))"
        bigLabel.frame = CGRect(x: 0, y: bounds.midY + 60, width: bounds.width, height: 50)
        addSubview(bigLabel)
        
        drawProtractor()
        
        progressBarBackgroundLayer = CAShapeLayer()
        progressBarBackgroundLayer.strokeColor = UIColor.gray.cgColor
        progressBarBackgroundLayer.lineWidth = 10
        progressBarBackgroundLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressBarBackgroundLayer)
        
        arrowLayer = CAShapeLayer()
        arrowLayer.fillColor = UIColor.green.cgColor
        layer.addSublayer(arrowLayer)
        
        progressBarLayer = CAShapeLayer()
        progressBarLayer.strokeColor = UIColor.red.cgColor
        progressBarLayer.lineWidth = 10
        progressBarLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(progressBarLayer)
        
        updateView()
    }
    
    func addLabels() {
        for view in subviews where view is UILabel && view != bigLabel {
            view.removeFromSuperview()
        }

        let numberOfLabels = 10
        let radius = bounds.width / 2 - 50
        let centerX = bounds.midX
        let centerY = bounds.midY + 100

        for number in 1...numberOfLabels {
            let angleInDegrees = 90 - CGFloat(number - 1) * 180 / CGFloat(numberOfLabels - 1)
            let angleInRadians = angleInDegrees * .pi / 180

            let labelX = centerX - radius * sin(angleInRadians) - 10
            let labelY = centerY - radius * cos(angleInRadians) - 10

            let label = UILabel(frame: CGRect(x: labelX, y: labelY, width: 20, height: 20))
            label.text = "\(number)"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = .black

            addSubview(label)
        }
    }

    private func drawProtractor() {
        protractorLayers.forEach { $0.removeFromSuperlayer() }
        protractorLayers.removeAll()

        let center = CGPoint(x: bounds.midX, y: bounds.midY + 100)
        let extraSpace: CGFloat = 15
        let bottomExtraSpace: CGFloat = 20
        let radius = bounds.width / 2 - 20

        // Upper Background Layer
        let upperBackgroundPath = UIBezierPath(arcCenter: center, radius: radius + extraSpace, startAngle: .pi, endAngle: 2 * .pi, clockwise: true)
        upperBackgroundPath.addLine(to: center)
        upperBackgroundPath.close()
        let upperBackgroundLayer = CAShapeLayer()
        upperBackgroundLayer.path = upperBackgroundPath.cgPath
        upperBackgroundLayer.fillColor = UIColor.lightGray.cgColor
        layer.insertSublayer(upperBackgroundLayer, at: 0)

        // Lower Background Layer
        let lowerBackgroundPath = UIBezierPath()
        lowerBackgroundPath.move(to: CGPoint(x: bounds.midX - radius - extraSpace, y: center.y))
        lowerBackgroundPath.addLine(to: CGPoint(x: bounds.midX + radius + extraSpace, y: center.y))
        lowerBackgroundPath.addLine(to: CGPoint(x: bounds.midX + radius + extraSpace, y: center.y + bottomExtraSpace))
        lowerBackgroundPath.addLine(to: CGPoint(x: bounds.midX - radius - extraSpace, y: center.y + bottomExtraSpace))
        lowerBackgroundPath.addLine(to: CGPoint(x: bounds.midX - radius - extraSpace, y: center.y))
        lowerBackgroundPath.close()
        let lowerBackgroundLayer = CAShapeLayer()
        lowerBackgroundLayer.path = lowerBackgroundPath.cgPath
        lowerBackgroundLayer.fillColor = UIColor.lightGray.cgColor
        layer.insertSublayer(lowerBackgroundLayer, at: 0)

        // Protractor Layer
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: .pi, endAngle: 2 * .pi, clockwise: true)
        path.addLine(to: center)
        path.close()
        let protractorLayer = CAShapeLayer()
        protractorLayer.path = path.cgPath
        protractorLayer.fillColor = UIColor.lightGray.cgColor
        layer.insertSublayer(protractorLayer, above: upperBackgroundLayer)

        protractorLayers = [upperBackgroundLayer, lowerBackgroundLayer, protractorLayer]
    }
    
    private func updateView() {
        drawArrow()
        drawProgressBar()
    }
    
    private func drawArrow() {
        let path = UIBezierPath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY + 100)
        let angle = .pi + selectedValue * .pi / 10
        let arrowLength: CGFloat = 100
        let startPoint = CGPoint(x: center.x + cos(angle) * (bounds.width / 2 - 20),
                                 y: center.y + sin(angle) * (bounds.width / 2 - 20))
        let endPoint = CGPoint(x: center.x + cos(angle) * (bounds.width / 2 - arrowLength),
                               y: center.y + sin(angle) * (bounds.width / 2 - arrowLength))
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.addLine(to: CGPoint(x: endPoint.x - 10 * sin(angle),
                                 y: endPoint.y + 10 * cos(angle)))
        path.addLine(to: CGPoint(x: endPoint.x + 10 * sin(angle),
                                 y: endPoint.y - 10 * cos(angle)))
        path.close()
        
        arrowLayer.path = path.cgPath
    }
    
    private func drawProgressBar() {
        let path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY + 100),
                                radius: bounds.width / 2 - 20,
                                startAngle: .pi,
                                endAngle: 2 * .pi,
                                clockwise: true)
        progressBarBackgroundLayer.path = path.cgPath
        
        let progressPath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY + 100),
                                        radius: bounds.width / 2 - 20,
                                        startAngle: .pi,
                                        endAngle: .pi + selectedValue * .pi / 10,
                                        clockwise: true)
        progressBarLayer.path = progressPath.cgPath
    }
}


