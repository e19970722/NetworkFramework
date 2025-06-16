//
//  NetworkHelper.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/4/28.
//

import Foundation
import Combine
import Network

class NetworkViewModel {
    
    /// The dictionary stores all the sockets
    private var socketsDict: [AppServer:SocketManager] = [:]
    
    /// The dictionary stores all the sockets connecting state
    @Published var socketsConnectedStateDict: [AppServer : Bool] = [:]
    

    func connectQuoteServer(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let quoteSocket = SocketManager(server: .quote , isTLS: true) else { return }
        if socketsDict[AppServer.quote] == nil {
            socketsDict[AppServer.quote] = quoteSocket
            quoteSocket.connectServer(completion: completion)
        }
    }
    
    func connectPushServer(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let pushSocket = SocketManager(server: .push , isTLS: true) else { return }
        if socketsDict[AppServer.push] == nil {
            socketsDict[AppServer.push] = pushSocket
            pushSocket.connectServer(completion: completion)
        }
    }
    
    func connectTradeServer() {
        guard let tradeSocket = SocketManager(server: .trade , isTLS: true) else { return }
        if socketsDict[AppServer.trade] == nil {
            socketsDict[AppServer.trade] = tradeSocket
            tradeSocket.connectServer { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    self.socketsConnectedStateDict[AppServer.trade] = true
                case .failure( _):
                    self.socketsConnectedStateDict[AppServer.trade] = false
                    break
                }
            }
        }
    }
    
    func connectAllServers() {
//        connectQuoteServer(completion: @escaping (Result<Void, Error>) -> Void))
//        connectPushServer(completion: @escaping (Result<Void, Error>) -> Void))
//        connectTradeServer(completion: @escaping (Result<Void, Error>) -> Void))
    }
}
