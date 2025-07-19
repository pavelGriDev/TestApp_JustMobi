//
//  View+ext.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 18.07.25.
//

import UIKit

extension UIView {
    func addSubviewsForAutoLayout(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
    }
}
