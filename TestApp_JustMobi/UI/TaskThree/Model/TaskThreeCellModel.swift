//
//  Item.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 23.07.25.
//

import Foundation

struct TaskThreeCellModel {
    
    private let model: BeardedMan
    
    init(model: BeardedMan) {
        self.model = model
    }
    
    var id: String { model.id }
    var imageUrl: String { model.url }
    var hashTags: [String] { model.tags }
}
