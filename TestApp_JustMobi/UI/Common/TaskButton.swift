//
//  TaskButton.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 21.07.25.
//

import UIKit

final class TaskButton: UIButton {
    
    convenience init(title: String) {
        self.init(type: .system)
        
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor.accentPurple
        layer.cornerRadius = 20
    }
}
