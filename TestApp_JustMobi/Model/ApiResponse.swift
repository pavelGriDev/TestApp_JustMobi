//
//  ApiResponce.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import Foundation

struct ApiResponse: Decodable {
    let data: [BeardedMan]
    let page: Int
}

struct BeardedMan: Decodable {
    let id: String
    let url: String
    let width: Double
    let height: Double
    let tags: [String]
}

#if DEBUG
class MockApiResponseBuilder {
    
    let beardHashtags = [
        "#beard", "#beardedStyle", "#beardGoals", "#fullBeard", "#shortBeard", "#goatee", "#beardTrimmed",
        "#hipsterLook", "#ruggedStyle", "#redBeard", "#blackBeard", "#grayBeard", "#curlyBeard",
        "#smoothBeard", "#urbanBeard", "#beardMinsk", "#beardMoscow", "#beardVilnius", "#winterBeard", "#beardAndGlasses"
    ]
    
    func createMockResponse(page: Int) -> ApiResponse {
        var models: [BeardedMan] = []
        for _ in 0..<30 {
            models.append(createRandomModel())
        }
        return ApiResponse(data: models, page: page)
    }
    
    private func createRandomModel() -> BeardedMan {
        let count = Int.random(in: 1...5)
        let hashTags = Array(beardHashtags.shuffled().prefix(count))
        let width = Double.random(in: 150...300)
        let height = Double.random(in: 200...300)
        
        let model = BeardedMan(
            id: UUID().uuidString,
            url: "https://placebeard.it/g/\(width)/\(height)",
            width: width,
            height: height,
            tags: hashTags
        )
        
        return model
    }
}
#endif
