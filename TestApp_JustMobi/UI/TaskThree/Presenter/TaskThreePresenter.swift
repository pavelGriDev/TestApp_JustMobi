//
//  TaskThreePresenter.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import Foundation

protocol TaskThreePresenterProtocol {
    func viewDidLoad()
}

final class TaskThreePresenter: TaskThreePresenterProtocol {
    
    weak var viewController: TaskThreeViewControllerProtocol?
    
    init(viewController: TaskThreeViewControllerProtocol?) {
        self.viewController = viewController
    }
    
    let dataSource: [Item] = [
        .init(id: 1, imageName: .image01),
        .init(id: 2, imageName: .image02),
        .init(id: 3, imageName: .image03),
        .init(id: 4, imageName: .image04),
        .init(id: 5, imageName: .image05),
        .init(id: 6, imageName: .image06),
        .init(id: 7, imageName: .image07),
        .init(id: 1, imageName: .image01),
        .init(id: 2, imageName: .image02)
    ]
    
    func viewDidLoad() {
        viewController?.display(content: dataSource)
    }
}
