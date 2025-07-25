//
//  ApiClient.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import Foundation

protocol ApiClientProtocol {
    func fetchRequest(page: Int, completion: @escaping (Result<ApiResponse, Error>) -> Void)
}

final class ApiClient: ApiClientProtocol {
    func fetchRequest(page: Int = 0, completion: @escaping (Result<ApiResponse, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + Double.random(in: 0.3...3.0)) {
            let response = MockApiResponseBuilder().createMockResponse(page: page)
            
            completion(.success(response))
        }
    }
}
