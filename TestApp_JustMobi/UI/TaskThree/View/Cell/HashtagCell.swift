//
//  HashtagCell.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import UIKit

final class HashtagCell: UICollectionViewCell {
    
    enum Appearance {
        static let horizontalLabelOffset: CGFloat = 12
        static let verticalLabelOffset: CGFloat = 6
        static let width: CGFloat = 25
        static let cornerRadius: CGFloat = 12
    }

    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .textBlue
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .textBlue.withAlphaComponent(0.8)
                hashtagLabel.textColor = .black
            } else {
                backgroundColor = .tagBackgroundBlue
                hashtagLabel.textColor = .textBlue
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        hashtagLabel.text = text
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        attributes.size = systemLayoutSizeFitting(
            CGSize(width: UIView.layoutFittingCompressedSize.width, height: Appearance.width),
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )
        return attributes
    }
}

private extension HashtagCell {
    func setup() {
        backgroundColor = .tagBackgroundBlue
        layer.cornerRadius = Appearance.cornerRadius
        self.contentView.addSubviewsForAutoLayout(hashtagLabel)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            hashtagLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Appearance.verticalLabelOffset),
            hashtagLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Appearance.horizontalLabelOffset),
            hashtagLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Appearance.horizontalLabelOffset),
            hashtagLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -Appearance.verticalLabelOffset)
        ])
    }
}
