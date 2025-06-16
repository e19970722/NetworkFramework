//
//  NetworkViewController.swift
//  20250428_NetworkFramework
//
//  Created by Yen Lin on 2025/4/28.
//

import UIKit
import Combine

class NetworkViewController: UIViewController {

    @IBOutlet weak var quoteServerLabel: UILabel!
    @IBOutlet weak var pushServerLabel: UILabel!
    @IBOutlet weak var tradeServerLabel: UILabel!
    
    private let viewModel = NetworkViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        
        self.viewModel.$socketsConnectedStateDict
            .receive(on: DispatchQueue.main)
            .sink { returnedDict in
                if let tradeState = returnedDict[AppServer.trade] {
                    let isConnectedSuffix = tradeState ? "Connected" : "Not Connected"
                    self.tradeServerLabel.text = "\(AppServer.trade.name) Server is \(isConnectedSuffix)."
                }
            }
            .store(in: &cancellables)
    }
    
    @IBAction func quoteButtonDidTapped(_ sender: UIButton) {
//        viewModel.connectQuoteServer()
    }
    
    @IBAction func pushButtonDidTapped(_ sender: UIButton) {
//        viewModel.connectPushServer()
    }
    
    @IBAction func tradeButtonDidTapped(_ sender: UIButton) {
        viewModel.connectTradeServer()
    }
    
    @IBAction func connectAllButtonDidTapped(_ sender: UIButton) {
    }
    
    @IBAction func disconnectAllButtonDidTapped(_ sender: UIButton) {
    }
    
}
