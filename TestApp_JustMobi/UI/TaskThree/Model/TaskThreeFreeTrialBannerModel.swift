//
//  TaskThreeFreeTrialModel.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import Foundation

struct TaskThreeFreeTrialBannerModel {
    let title: String
    let bodyText: String
    let smallImages: [ImageResource]
    let largeImages: [ImageResource]
    
    static var getModel: TaskThreeFreeTrialBannerModel {
        .init(
            title: "Try three days free trial",
            bodyText: "You will get all premium templates, additional stickers and no ads",
            smallImages: [.freeTrialImage02, .freeTrialImage03],
            largeImages: [.freeTrialImage01, .freeTrialImage04]
        )
    }
}
