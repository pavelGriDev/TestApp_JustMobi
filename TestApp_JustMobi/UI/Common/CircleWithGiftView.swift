//
//  CircleWithGiftView.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 21.07.25.
//

import UIKit

@MainActor
final class CircleWithGiftView: UIView {
    
    enum Appearance {
        static let imageHorizontalInsetRatio: CGFloat = 0.18
        static let imageBottomInsetRatio: CGFloat = 0.36
        static let textBottomInsetRatio: CGFloat = 0.18
        
        static let textTopOffset: CGFloat = 6
        static let textHorizontalOffset: CGFloat = 8
    }
    
    private let imageName: ImageResource
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: UIImage(resource: self.imageName))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = StrokedTextLabel(strokeSize: 2, strokeColor: .black)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    init(imageName: ImageResource) {
        self.imageName = imageName
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.6)
        clipsToBounds = true
        
        self.addSubviewsForAutoLayout(imageView, textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        setupAnimation()
    }
    
    func stopAnimation() {
        imageView.layer.removeAnimation(forKey: "giftAnimation")
    }
    
    func setTime(_ seconds: Int) {
        textLabel.text = formatTime(seconds)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
        setupLayout()
    }
    
    private func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func setupLayout() {
        let horizontalInset = self.bounds.width * Appearance.imageHorizontalInsetRatio
        let bottomInset = self.bounds.height * Appearance.imageBottomInsetRatio
        let textBottomInset = self.bounds.height * Appearance.textBottomInsetRatio
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: horizontalInset),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -horizontalInset),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomInset),
            
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Appearance.textTopOffset),
            textLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: Appearance.textHorizontalOffset),
            textLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -Appearance.textHorizontalOffset),
            textLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -textBottomInset)
        ])
    }
}


// MARK: - Animation

private extension CircleWithGiftView {
    
    private func setupAnimation() {
        // animation frames
        // 54 (pause), 30 (animation), 34 (pause), 30 (animation), 94 (pause)
        
        let pauseFrames = [54.0, 34.0, 94.0]
        let rotationFrame = 30.0
        let frameDuration: TimeInterval = 1.0 / 60.0
        
        let pause1Duration: CFTimeInterval = pauseFrames[0] * frameDuration
        let pause2Duration: CFTimeInterval = pauseFrames[1] * frameDuration
        let pause3Duration: CFTimeInterval = pauseFrames[2] * frameDuration
        let rotationDuration: CFTimeInterval = rotationFrame * frameDuration
        
        let rotationAngle = -CGFloat.pi * 0.08
        
        let delay1 = createDelayAnimation(
            beginTime: 0.0,
            duration: pause1Duration
        )
        
        let rotation1 = createRotationAnimation(
            angle: rotationAngle,
            beginTime: pause1Duration,
            duration: rotationDuration
        )
        
        let delay2 = createDelayAnimation(
            beginTime: pause1Duration + rotationDuration,
            duration: pause2Duration
        )
        
        let rotation2 = createRotationAnimation(
            angle: rotationAngle,
            beginTime: pause1Duration + rotationDuration + pause2Duration,
            duration: rotationDuration
        )
        
        let delay3 = createDelayAnimation(
            beginTime: pause1Duration + rotationDuration * 2 + pause2Duration,
            duration: pause3Duration
        )
        
        let totalDuration = pause1Duration + rotationDuration * 2 + pause2Duration + pause3Duration
        let group = CAAnimationGroup()
        group.animations = [delay1, rotation1, delay2, rotation2, delay3]
        group.duration = totalDuration
        group.repeatCount = .infinity
        
        imageView.layer.add(group, forKey: "giftAnimation")
    }

    private func createDelayAnimation(beginTime: CFTimeInterval, duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 1.0
        animation.beginTime = beginTime
        animation.duration = duration
        return animation
    }

    private func createRotationAnimation(angle: CGFloat, beginTime: CFTimeInterval, duration: CFTimeInterval) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.values = [0.0, angle, 0.0, angle, 0.0, angle, 0.0]
        animation.keyTimes = [0.0, 0.15, 0.3, 0.45, 0.6, 0.75, 1.0]
        animation.beginTime = beginTime
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
}
