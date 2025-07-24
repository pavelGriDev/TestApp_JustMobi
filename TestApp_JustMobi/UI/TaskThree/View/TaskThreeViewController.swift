//
//  TaskThreeViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 21.07.25.
//

import UIKit
import CHTCollectionViewWaterfallLayout

protocol TaskThreeViewControllerProtocol: AnyObject {
    func displayTrialBanner(with model: TaskThreeFreeTrialBannerModel, isVisible: Bool)
    func display(hashTags: [String])
    func display(models: [TaskThreeCellModel])
    func setLoadingVisible(_ isVisible: Bool)
}

final class TaskThreeViewController: UIViewController, TaskThreeViewControllerProtocol {
    
    enum Appearance {
        static let horizontalOffset: CGFloat = 16
        static let bannerWidth: CGFloat = 108
        static let contentSpacing: CGFloat = 15
        // collection content
        static let horizontalInset: CGFloat = 16
        static let verticalInset: CGFloat = 8
        static let spacing: CGFloat = 8
    }
    
    var presenter: TaskThreePresenterProtocol?
    
    private var cellModels = [TaskThreeCellModel]()
    
    private lazy var trialBannerView = FreeTrialBannerView()
    private lazy var hashtagsListView = HashtagsListView()
    private lazy var loadingView = LoadingView()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Appearance.contentSpacing
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CHTCollectionViewWaterfallLayout()
        layout.columnCount = 2
        layout.minimumInteritemSpacing = Appearance.spacing
        layout.minimumColumnSpacing = Appearance.spacing
        layout.sectionInset = UIEdgeInsets(
            top: Appearance.verticalInset,
            left: Appearance.horizontalInset,
            bottom: Appearance.verticalInset,
            right: Appearance.horizontalInset
        )
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
    
    func displayTrialBanner(with model: TaskThreeFreeTrialBannerModel, isVisible: Bool) {
        trialBannerView.isHidden = !isVisible
        if isVisible {
            trialBannerView.configure(with: model)
        }
    }
    
    func display(hashTags: [String]) {
        DispatchQueue.main.async {
            self.hashtagsListView.configure(with: hashTags)
        }
    }
    
    func display(models: [TaskThreeCellModel]) {
        cellModels = models
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setLoadingVisible(_ isVisible: Bool) {
        DispatchQueue.main.async {
            if isVisible {
                self.loadingView.start()
            } else {
                self.loadingView.stop()
            }
        }
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
        
        [trialBannerView, hashtagsListView, collectionView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        hashtagsListView.delegate = self
        
        view.addSubviewsForAutoLayout(contentStackView)
        view.addSubviewsForAutoLayout(loadingView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            trialBannerView.heightAnchor.constraint(equalToConstant: Appearance.bannerWidth),
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension TaskThreeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TaskThreeCell.cellReuseIdentifier,
            for: indexPath
        ) as? TaskThreeCell else {
            fatalError("Cannot dequeue cell for identifier: \(TaskThreeCell.cellReuseIdentifier)")
        }
        
        let item = cellModels[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension TaskThreeViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = Appearance.horizontalInset * 2
        let spacing: CGFloat = Appearance.verticalInset
        
        let availableWidth = view.frame.width - padding - spacing
        let width = availableWidth / 2
        let originalSize = cellModels[indexPath.item].size
        let scale = width / originalSize.width
        let height = originalSize.height * scale

        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.printItems("selected item: \(indexPath.item)")
    }
}

extension TaskThreeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.first else { return }
        
        if indexPath.item == cellModels.count - 5 {
            print("Load more items....")
        }
        
//        print("prefetchItemsAt: \(indexPath.item)")
    }
}

extension TaskThreeViewController: HashtagsListDelegate {
    func didSelectHashtag(at index: Int) {
        presenter?.didSelectHashtag(at: index)
    }
}
