//
//  TaskThreePresenter.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import Foundation

protocol TaskThreePresenterProtocol {
    func viewDidLoad()
    func viewDidDisappear()
    func didSelectHashtag(at index: Int)
    func showGiftIfNeeded(completion: (Int) -> Void)
    func giftGestureTapped()
}

final class TaskThreePresenter: TaskThreePresenterProtocol {
    
    private weak var viewController: TaskThreeViewControllerProtocol?
    private let apiClient: ApiClientProtocol
    
    private var cellModels = [TaskThreeCellModel]()
    private var hashTags = [String]()
    private var showTrialBanner = true
    private var contentPage = 0
    
    private var showGift = true
    private var timeLimit = 1200
    private weak var giftTimer: Timer?
    
    init(
        viewController: TaskThreeViewControllerProtocol?,
        apiClient: ApiClientProtocol
    ) {
        self.viewController = viewController
        self.apiClient = apiClient
    }
    
    // MARK: - TaskThreePresenterProtocol
    
    func viewDidLoad() {
        // a temporary solution that needs to be moved to AppStateService
        showTrialBanner = true
    
        viewController?.displayTrialBanner(with: TaskThreeFreeTrialBannerModel.getModel, isVisible: showTrialBanner)
        request()
    }
    
    func viewDidDisappear() {
        // TODO: save time to local storage if needed
        stopTimer()
    }
    
    func didSelectHashtag(at index: Int) {
        Logger.printItems("hashTag index: \(index)")
    }
    
    func showGiftIfNeeded(completion: (Int) -> Void) {
        if showGift {
            completion(timeLimit)
            createTimer()
        }
    }
    
    func giftGestureTapped() {
        // some logic
    }
}

// MARK: - Private Methods

private extension TaskThreePresenter {
    func request() {
        viewController?.setLoadingVisible(true)
        apiClient.fetchRequest(page: contentPage) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                cellModels = response.data.map { TaskThreeCellModel(model: $0) }
                hashTags = Array(Set(response.data.flatMap { $0.tags }))
                viewController?.display(models: cellModels)
                viewController?.display(hashTags: hashTags)
            case .failure(let error):
                // TODO: show an error message with an empty view
                Logger.printError("Failed request with error: \(error)")
            }
            viewController?.setLoadingVisible(false)
        }
    }
}

// MARK: - Timer

private extension TaskThreePresenter {
    
    func createTimer() {
        stopTimer()
        giftTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            timeLimit -= 1
            viewController?.updateGiftTimer(time: timeLimit)
            
            if timeLimit <= 0 {
                stopTimer()
                viewController?.giftTimerDidEnd()
            }
        })
        
        if let giftTimer {
            giftTimer.tolerance = 0.4
            RunLoop.main.add(giftTimer, forMode: .common)
        }
    }

    func stopTimer() {
        giftTimer?.invalidate()
        giftTimer = nil
    }
}
