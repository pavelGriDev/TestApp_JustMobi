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
    func updateGiftTimer(time: Int)
    func giftTimerDidEnd()
    func setLoadingVisible(_ isVisible: Bool)
}

final class TaskThreeViewController: UIViewController, TaskThreeViewControllerProtocol {
    
    enum Appearance {
        static let horizontalOffset: CGFloat = 16
        static let contentSpacing: CGFloat = 15
        static let giftWidth: CGFloat = 88
        static let giftBottomOffset: CGFloat = 7
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
    
    private lazy var giftView: CircleWithGiftView = {
        let view = CircleWithGiftView(imageName: .giftBoxRed)
        view.isHidden = true
        return view
    }()
    
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
    
    // MARK: - Life Circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setup()
        setupLayout()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        presenter?.showGiftIfNeeded { [weak self] timeLimit in
//            guard let self else { return }
//            giftView.isHidden = false
//            giftView.startAnimation()
//            giftView.setTime(timeLimit)
//        }
//    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter?.viewDidDisappear()
        giftView.stopAnimation()
    }
}

// MARK: - TaskThreeViewControllerProtocol

extension TaskThreeViewController {
    
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
            UIView.transition(with: self.collectionView, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self.collectionView.reloadData()
            })
            
            self.presenter?.showGiftIfNeeded { [weak self] timeLimit in
                guard let self else { return }
                giftView.isHidden = false
                giftView.startAnimation()
                giftView.setTime(timeLimit)
            }
        }
    }
    
    func updateGiftTimer(time: Int) {
        giftView.setTime(time)
    }
    
    func giftTimerDidEnd() {
        giftView.isHidden = true
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
}

// MARK: - Private Methods

private extension TaskThreeViewController {
    
    func setup() {
        view.backgroundColor = UIColor.black
        
        [trialBannerView, hashtagsListView, collectionView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        hashtagsListView.delegate = self
        view.addSubviewsForAutoLayout(contentStackView)
        view.addSubviewsForAutoLayout(loadingView)
        view.addSubviewsForAutoLayout(giftView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(giftTapGesture))
        giftView.addGestureRecognizer(tapGesture)
    }
    
    @objc func giftTapGesture() {
        presenter?.giftGestureTapped()
        Logger.printItems("Show a gift...")
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            giftView.widthAnchor.constraint(equalToConstant: Appearance.giftWidth),
            giftView.heightAnchor.constraint(equalTo: giftView.widthAnchor),
            giftView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Appearance.horizontalOffset),
            giftView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Appearance.giftBottomOffset),
            
            contentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UICollectionViewDataSource

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

// MARK: - CHTCollectionViewDelegateWaterfallLayout

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

// MARK: - UICollectionViewDataSourcePrefetching

extension TaskThreeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.first else { return }
        
        if indexPath.item == cellModels.count - 5 {
            print("Load more items....")
        }
        
    }
}

// MARK: - HashtagsListDelegate

extension TaskThreeViewController: HashtagsListDelegate {
    func didSelectHashtag(at index: Int) {
        presenter?.didSelectHashtag(at: index)
    }
}
