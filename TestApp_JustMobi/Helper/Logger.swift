//
//  Logger.swift
//  TestApp_JustMobi
//
//  Created by Pavel Gritskov on 24.07.25.
//

import Foundation

class Logger {
    
    static func printItems(_ items: Any...) {
        #if DEBUG
        print("-->",items)
        #endif
    }
    
    private init() {}
}
