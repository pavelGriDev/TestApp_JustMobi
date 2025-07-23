//
//  Cell+reu.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import UIKit

extension UICollectionViewCell {
    static var cellReuseIdentifier: String {
        String(describing: Self.self)
    }
}
