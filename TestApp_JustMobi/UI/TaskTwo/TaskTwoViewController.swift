//
//  TaskTwoViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 25.07.25.
//

import UIKit

final class TaskTwoViewController: UIViewController {
    
    private let trialBannerView = FreeTrialBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
}

// MARK: - Private Methods

private extension TaskTwoViewController {
    
    func setup() {
        view.backgroundColor = .black
        view.addSubviewsForAutoLayout(trialBannerView)
        let model = TaskThreeFreeTrialBannerModel.getModel
        trialBannerView.configure(with: model)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            trialBannerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            trialBannerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trialBannerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
