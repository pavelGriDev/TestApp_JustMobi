//
//  HashtagsListView.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import UIKit

protocol HashtagsListDelegate: AnyObject {
    func didSelectHashtag(at index: Int)
}

final class HashtagsListView: UIView {
    
    enum Appearance {
        static let horizontalLabelOffset: CGFloat = 16
        static let collectionWidth: CGFloat = 25
        static let topCollectionOffset: CGFloat = 8
        // collection content
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 0
        static let spacing: CGFloat = 4
    }
    
    weak var delegate: HashtagsListDelegate?
    
    private var content: [String] = []
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.text = "Подходит для:"
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = Appearance.spacing
        layout.minimumLineSpacing = Appearance.spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HashtagCell.self, forCellWithReuseIdentifier: HashtagCell.cellReuseIdentifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(
            top: Appearance.verticalInset,
            left: Appearance.horizontalInset,
            bottom: Appearance.verticalInset,
            right: Appearance.horizontalInset
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupLayout()
    }
    
    func configure(with content: [String]) {
        self.content = content
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HashtagsListView {
    
    func setup() {
        addSubviewsForAutoLayout(headerLabel, collectionView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Appearance.horizontalLabelOffset),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Appearance.horizontalLabelOffset),
            
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Appearance.topCollectionOffset),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Appearance.collectionWidth)
        ])
    }
}

extension HashtagsListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HashtagCell.cellReuseIdentifier,
            for: indexPath) as? HashtagCell
        else {
            fatalError("Cannot dequeue cell for identifier: \(HashtagCell.cellReuseIdentifier)")
        }
        
        cell.configure(with: content[indexPath.item])
        return cell
    }
}

extension HashtagsListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectHashtag(at: indexPath.item)
    }
}
