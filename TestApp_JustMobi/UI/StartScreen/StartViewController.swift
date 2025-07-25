//
//  StartViewController.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 21.07.25.
//

import UIKit

final class StartViewController: UIViewController {
    
    private let taskOneButton = TaskButton(title: "Task One")
    private let taskTwoButton = TaskButton(title: "Task Two")
    private let taskThreeButton = TaskButton(title: "Task Three")
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
}

// MARK: - Setup

private extension StartViewController {
    func setup() {
        view.backgroundColor = .white
        
        [taskOneButton, taskTwoButton, taskThreeButton].enumerated().forEach {
            stackView.addArrangedSubview($1)
            $1.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            $1.tag = $0
        }
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        view.addSubviewsForAutoLayout(stackView)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            let taskOneViewController = TaskOneViewController()
            navigationController?.pushViewController(taskOneViewController, animated: true)
        case 1:
            let taskTwoViewController = TaskTwoViewController()
            navigationController?.pushViewController(taskTwoViewController, animated: true)
        case 2:
            let taskThreeViewController = TaskThreeBuilder().build()
            navigationController?.pushViewController(taskThreeViewController, animated: true)
        default:
            break
        }
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            stackView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ])
    }
}
