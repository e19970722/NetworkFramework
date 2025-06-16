//
//  SocketManager.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/4/28.
//

import Foundation
import Network

class SocketManager {

    /// Assign a custom header to communicate with server
    private let customHeaderStr = "JTkoQP//AAAAAAAAzwcAAA=="
    
    private let serverType: AppServer
    private let queue: DispatchQueue
    
    private var connection: NWConnection?
    private let host: NWEndpoint.Host
    private let port: NWEndpoint.Port
    private let parameter: NWParameters
    
    private var sendPackageByte: UInt64 = 0
    
    /// send heartbeat every 30 secs
    private let echoTime: Double = 30.0
    /// if heartbeat has no response over 10 secs considers as a timeout
    private let heartbeatTimeoutTime: Double = 10.0
    /// if timeout occurs, reconnect every 2 secs
    private let reconnectTime: Double = 2.0
    private var echoTimer: Timer?
    private var heartbeatTimer: Timer?
    
    var isConnected: Bool {
        connection?.state == .ready
    }
    
    init?(server: AppServer, isTLS: Bool) {
        self.serverType = server
        self.queue = DispatchQueue(label: "\(serverType.name)socketQueue")
        self.host = NWEndpoint.Host(serverType.host)
        guard let inputPort = NWEndpoint.Port(rawValue: serverType.port) else {
            return nil
        }
        self.port = inputPort
        self.parameter = isTLS ? .tcp : .tls
    }
    
    func connect() {
        self.connection = NWConnection(host: host, port: port, using: parameter)
        self.connection?.stateUpdateHandler = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .ready:
                self.didConnectServer()
                print("✅ \(serverType.name)Server connect state: \(state).")
                
            case .failed(let error):
                print("❌ \(serverType.name)Server connect error: \(error.localizedDescription).")
                
            default:
                break
            }
        }
        self.connection?.start(queue: self.queue)
    }
    
    func connect(host: String?, port: UInt16?) {
        guard let hostString = host,
              let portString = port,
              let port = NWEndpoint.Port(rawValue: portString) else {
            print("⛔️ invalid host or port.")
            return
        }
        let host = NWEndpoint.Host(hostString)
        self.connection = NWConnection(host: host, port: port, using: parameter)
        self.connection?.stateUpdateHandler = { state in
            print("state: \(state)")
        }
        self.connection?.start(queue: self.queue)
    }
    
    func disconnect() {
        self.connection?.cancel()
        self.connection = nil
        self.echoTimer?.invalidate()
        self.echoTimer = nil
        self.heartbeatTimer?.invalidate()
        self.heartbeatTimer = nil
        print("⏹️ \(serverType.name)Server has disconnected.")
    }
    
    func sendData() {
        
    }
    
    func readData() {
        
    }
    
    private func didConnectServer() {
        self.sendEcho()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.echoTimer = Timer.scheduledTimer(withTimeInterval: self.echoTime,
                                             repeats: true) { timer in
                self.sendEcho()
            }
        }
    }
    
    private func sendEcho() {
        print("🟠 \(self.serverType.name)Server Send Echo")
        
        // TODO: 還沒組裝好Header，先用下方的testStr
        let headSpecStr = "%9(@"
        let header = customHeader(Headspec: Array(headSpecStr.utf8),
                                  serialNo: 65535,
                                  dataLength: 0,
                                  orderNo: 1999)
        var headerData = header.toData()
        
        guard let headerData = Data(base64Encoded: self.customHeaderStr) else { return }
        self.sendPackageByte += UInt64(headerData.count)
        self.connection?.send(content: headerData, completion: .contentProcessed({ [weak self] error in
            guard let self = self else { return }
            if let error = error {
                print("Write Data Error: \(error.localizedDescription)")
            } else {
                self.receiveEcho()
                DispatchQueue.main.async {
                    self.heartbeatTimer = Timer.scheduledTimer(withTimeInterval: self.heartbeatTimeoutTime,
                                                               repeats: false, block: { _ in
                        print("🔴 \(self.serverType.name)Server Send Echo Failed")
                    })
                }
            }
        }))
    }
    
    private func receiveEcho() {
        self.connection?.receive(minimumIncompleteLength: 1, maximumLength: 4096, completion: { content, contentContext, isComplete, error in
            if let content = content, !content.isEmpty {
                print("🟢 \(self.serverType.name)Server Receive Echo")
                self.heartbeatTimer?.invalidate()
            }
            
            if let error = error {
                print("🔴 \(self.serverType.name)Server Receive Echo Error: \(error.localizedDescription)")
            }
        })
    }
    
    private func processEchoData(data: Data, socket: AppServer) {

    }
    
}
