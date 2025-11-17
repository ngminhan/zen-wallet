//
//  CircularProgressBarView.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import UIKit

final class CircularProgressBarView: UIView {
    
    private struct Appearance {
        static let lineWidth: CGFloat = 20.0
        static let backgroundColor = UIColor.clear
        static let progressColor = UIColor.greenSheen
    }
    
    private lazy var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 0
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Appearance.progressColor.cgColor
        
        return layer
    }()
    
    private lazy var backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = Appearance.lineWidth
        layer.lineCap = .round
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = Appearance.backgroundColor.cgColor
        
        return layer
    }()
    
    init() {
        super.init(frame: .zero)
        loadLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadLayout() {
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
            radius: (bounds.width - Appearance.lineWidth) / 2,
            startAngle: -CGFloat.pi / 2,
            endAngle: CGFloat.pi * 3 / 2,
            clockwise: true
        ).cgPath
        
        backgroundLayer.path = circlePath
        progressLayer.path = circlePath
    }
    
    func setProgress(_ progress: CGFloat, animated: Bool) {
        let clampedProgress = max(min(progress, 1), 0)
        let oldValue = progressLayer.strokeEnd
        
        progressLayer.strokeEnd = clampedProgress
        
        if animated {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = oldValue
            animation.toValue = clampedProgress
            animation.duration = 0.5
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            progressLayer.add(animation, forKey: "progress")
        }
    }
}
