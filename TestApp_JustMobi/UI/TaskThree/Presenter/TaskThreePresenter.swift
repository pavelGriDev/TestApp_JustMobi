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
        .init(id: 8, imageName: .image01),
        .init(id: 9, imageName: .image02),
        .init(id: 10, imageName: .image01),
        .init(id: 11, imageName: .image01),
        .init(id: 12, imageName: .image02),
        .init(id: 13, imageName: .image03),
        .init(id: 14, imageName: .image04),
        .init(id: 15, imageName: .image05),
        .init(id: 16, imageName: .image06),
        .init(id: 17, imageName: .image07),
        .init(id: 18, imageName: .image01),
        .init(id: 19, imageName: .image02),
    ]
    
    func viewDidLoad() {
        viewController?.display(content: dataSource)
    }
}
