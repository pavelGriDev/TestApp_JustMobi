//
//  FreeTrialBunnerView.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import UIKit

final class FreeTrialBannerView: UIView {
    
    enum Appearance {
        static let bannerHeight: CGFloat = 108
        static let horizontalOffset: CGFloat = 16
        // stackView conteiner
        static let stackVerticalOffset: CGFloat = 14
        static let stackHorizontalOffset: CGFloat = 20
        static let stackSpacing: CGFloat = 20
        // imageStack
        static let stackWidth: CGFloat = 98
        static let stackHeight: CGFloat = 80
        // textStack
        static let textStackSpacing: CGFloat = 8
        static let textStackVerticalInset: CGFloat = 8
        
        static let spacingBetweenImages: CGFloat = 6
        static let cornerRadius: CGFloat = 12
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.5)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TaskThreeFreeTrialBannerModel) {
        titleLabel.text = model.title
        bodyLabel.text = model.bodyText
    }
}

// MARK: - Private Methods

private extension FreeTrialBannerView {
    
    func setup() {
        let contentContainer = UIView()
        contentContainer.backgroundColor = UIColor.accentPurple
        contentContainer.layer.cornerRadius = Appearance.cornerRadius
        
        let column1 = UIStackView(arrangedSubviews: [
            makeImageView(with: .freeTrialImage01), makeImageView(with: .freeTrialImage02)
        ])
        column1.axis = .vertical
        column1.spacing = Appearance.spacingBetweenImages
        column1.distribution = .fillProportionally
        column1.alignment = .leading
        
        let column2 = UIStackView(arrangedSubviews: [
            makeImageView(with: .freeTrialImage03), makeImageView(with: .freeTrialImage04)
        ])
        column2.axis = .vertical
        column2.spacing = Appearance.spacingBetweenImages
        column2.distribution = .fillProportionally
        column2.alignment = .leading
        
        let imageContainerStackView = UIStackView(arrangedSubviews: [column1, column2])
        imageContainerStackView.spacing = Appearance.spacingBetweenImages
        imageContainerStackView.distribution = .fillEqually
        imageContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = Appearance.textStackSpacing
        textStackView.isLayoutMarginsRelativeArrangement = true
        textStackView.layoutMargins = UIEdgeInsets(
            top: Appearance.textStackVerticalInset,
            left: 0,
            bottom: Appearance.textStackVerticalInset,
            right: 0
        )
        [titleLabel, bodyLabel].forEach { textStackView.addArrangedSubview($0) }
        
        let contentStackView = UIStackView()
        contentStackView.spacing = Appearance.stackSpacing
        
        contentContainer.addSubviewsForAutoLayout(contentStackView)
        contentStackView.addArrangedSubview(textStackView)
        contentStackView.addArrangedSubview(imageContainerStackView)
        self.addSubviewsForAutoLayout(contentContainer)
    
        NSLayoutConstraint.activate([
            imageContainerStackView.widthAnchor.constraint(equalToConstant: Appearance.stackWidth),
            imageContainerStackView.heightAnchor.constraint(equalToConstant: Appearance.stackHeight),
            
            self.heightAnchor.constraint(equalToConstant: Appearance.bannerHeight),
            
            contentContainer.topAnchor.constraint(equalTo: self.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Appearance.horizontalOffset),
            contentContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Appearance.horizontalOffset),
            contentContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Appearance.stackVerticalOffset),
            contentStackView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: Appearance.stackHorizontalOffset),
            contentStackView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -Appearance.stackHorizontalOffset),
            contentStackView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -Appearance.stackVerticalOffset),
        ])
    }
    
    private func makeImageView(with imageName: ImageResource) -> UIImageView {
        let imageView = UIImageView(image: UIImage(resource: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .brown
        imageView.layer.cornerRadius = 3
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }
}
