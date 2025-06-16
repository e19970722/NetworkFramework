//
//  NetworkHelper.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/4/28.
//

import Foundation
import Combine
import Network

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
        case .quote:          return "61.220.141.148"
        case .push:           return "61.220.141.148"
        case .trade:          return "210.202.246.170"
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

class NetworkHelper {
    
    private var socketsDict: [AppServer:SocketManager] = [:]

    func connectQuoteServer() {
        let quoteSocket = SocketManager(server: .quote , isTLS: true)
        if socketsDict[AppServer.quote] == nil {
            socketsDict[AppServer.quote] = quoteSocket
            guard let quoteSocket = quoteSocket else { return }
            quoteSocket.connect()
        }
    }
    
    func connectPushServer() {
        let pushSocket = SocketManager(server: .push , isTLS: true)
        if socketsDict[AppServer.push] == nil {
            socketsDict[AppServer.push] = pushSocket
            guard let pushSocket = pushSocket else { return }
            pushSocket.connect()
        }
    }
    
    func connectTradeServer() {
        let tradeSocket = SocketManager(server: .trade , isTLS: true)
        if socketsDict[AppServer.trade] == nil {
            socketsDict[AppServer.trade] = tradeSocket
            guard let tradeSocket = tradeSocket else { return }
            tradeSocket.connect()
        }
    }
    
    func connectAllServers() {
        connectQuoteServer()
        connectPushServer()
        connectTradeServer()
    }
}
