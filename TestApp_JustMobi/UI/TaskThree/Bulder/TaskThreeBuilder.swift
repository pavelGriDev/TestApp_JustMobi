//
//  TaskThreeBuilder.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import Foundation

final class TaskThreeBuilder {
    func build() -> TaskThreeViewController {
        let viewController = TaskThreeViewController()
        
        // here is no DI yet, the ApiClient is temporarily created here
        let apiClient = ApiClient()
        let presenter = TaskThreePresenter(viewController: viewController, apiClient: apiClient)
        viewController.presenter = presenter
        return viewController
    }
}
