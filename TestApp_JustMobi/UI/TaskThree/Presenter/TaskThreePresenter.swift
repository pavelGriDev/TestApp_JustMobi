//
//  TaskThreePresenter.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import Foundation

protocol TaskThreePresenterProtocol {
    func viewDidLoad()
    func didSelectHashtag(at index: Int)
}

final class TaskThreePresenter: TaskThreePresenterProtocol {
    
    private weak var viewController: TaskThreeViewControllerProtocol?
    private let apiClient: ApiClientProtocol
    
    private var cellModels = [TaskThreeCellModel]()
    private var hashTags = [String]()
    private var showTrialBanner = true
    private var contentPage = 0
    
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
    
    func didSelectHashtag(at index: Int) {
        Logger.printItems("hashTag index: \(index)")
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
