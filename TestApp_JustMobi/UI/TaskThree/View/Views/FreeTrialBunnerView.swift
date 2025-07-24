//
//  FreeTrialBunnerView.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import UIKit

final class FreeTrialBannerView: UIView {
    
    enum Appearance {
        static let horizontalOffset: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let titleTopOffset: CGFloat = 22
        static let titleLeftOffset: CGFloat = 20
        static let titleRightOffset: CGFloat = 152
    }
    
    private let contentContainer = UIView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TaskThreeFreeTrialBannerModel) {
        titleLabel.text = model.title
    }
}

private extension FreeTrialBannerView {
    
    func setup() {
        contentContainer.backgroundColor = UIColor.accentPurple
        contentContainer.layer.cornerRadius = Appearance.cornerRadius
        contentContainer.addSubviewsForAutoLayout(titleLabel)
        self.addSubviewsForAutoLayout(contentContainer)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: self.topAnchor),
            contentContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Appearance.horizontalOffset),
            contentContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Appearance.horizontalOffset),
            contentContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: Appearance.titleTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: Appearance.titleLeftOffset),
            titleLabel.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -Appearance.titleRightOffset)
        ])
    }
}
