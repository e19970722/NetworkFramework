//
//  AppServer.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/6/16.
//

public enum AppServer: CaseIterable {
    case quote
    case push
    case trade
    
    public var name: String {
        switch self {
        case .quote:          return "Quote"
        case .push:           return "Push"
        case .trade:          return "Trade"
        }
    }
    
    public var host: String {
        switch self {
        case .quote:          return ""
        case .push:           return ""
        case .trade:          return ""
        }
    }
    
    public var port: UInt16 {
        switch self {
        case .quote:          return 9671
        case .push:           return 8070
        case .trade:          return 9671
        }
    }
}
