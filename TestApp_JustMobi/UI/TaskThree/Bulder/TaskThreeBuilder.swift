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
        let presenter = TaskThreePresenter(viewController: viewController)
        viewController.presenter = presenter
        return viewController
    }
}
