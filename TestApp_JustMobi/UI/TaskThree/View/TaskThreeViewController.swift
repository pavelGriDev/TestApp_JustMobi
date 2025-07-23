//
//  TaskThreeViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 21.07.25.
//

import UIKit

protocol TaskThreeViewControllerProtocol: AnyObject {
    func display(content: [Item])
}

final class TaskThreeViewController: UIViewController, TaskThreeViewControllerProtocol {
    
    enum Appearance {
        static let horizontalOffset: CGFloat = 16
        static let bannerWidth: CGFloat = 108
    }
    
    var presenter: TaskThreePresenterProtocol?
    
    private var content: [Item] = []
    
    private lazy var bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.accentPurple
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var fitsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.text = "Подходит для:"
        return label
    }()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(TaskThreeCell.self, forCellWithReuseIdentifier: TaskThreeCell.cellReuseIdentifier)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: - TaskThreeViewControllerProtocol
    
    func display(content: [Item]) {
        self.content = content
    }
    
    
    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setup()
        setupLayout()
    }
}

private extension TaskThreeViewController {
    
    func setup() {
        view.backgroundColor = UIColor.black
        scrollView.addSubviewsForAutoLayout(stackView)
        view.addSubviewsForAutoLayout(bannerView, fitsLabel, scrollView, collectionView)
        
        let hashtags = ["#Осень", "#Insta-стиль", "#Мода2023", "#Одежда", "#Аксессуары"]

        for (index, tag) in hashtags.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(tag, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
            button.tintColor = .textBlue
            button.backgroundColor = .tagBackgroundBlue
            button.layer.cornerRadius = 12
            button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
            button.sizeToFit()
            button.addTarget(self, action: #selector(tagButtonHandler), for: .touchUpInside)
            button.tag = index
            stackView.addArrangedSubview(button)
        }
    }
    
    @objc func tagButtonHandler(_ sender: UIButton) {
        print("button tag: \(sender.tag)")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Appearance.horizontalOffset),
            bannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Appearance.horizontalOffset),
            bannerView.heightAnchor.constraint(equalToConstant: Appearance.bannerWidth),
            
            // fitsLabel
            fitsLabel.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 15),
            fitsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Appearance.horizontalOffset),
            fitsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Appearance.horizontalOffset),
            
            // scroll
            scrollView.topAnchor.constraint(equalTo: fitsLabel.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 25),
            
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            // collection
            collectionView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TaskThreeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskThreeCell.cellReuseIdentifier,
            for: indexPath
        ) as? TaskThreeCell else {
            fatalError("Не удалось деконструировать PhotoCell")
        }
        
        let item = content[indexPath.item]
        cell.imageView.image = UIImage(resource: item.imageName)
        cell.layer.cornerRadius = 14
        cell.clipsToBounds = true
        return cell
    }
}

extension TaskThreeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16 * 2
        let spacing: CGFloat = 8
        let availableWidth = view.frame.width - padding - spacing
        let width = availableWidth / 2
        return CGSize(width: width, height: width * 1.5)
    }
}

extension TaskThreeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("prefetchItemsAt: \(indexPath.item)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            print("cancelPrefetchingForItemsAt: \(indexPath.item)")
        }
    }
}
