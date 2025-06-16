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
    
    private let helper = NetworkHelper()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func quoteButtonDidTapped(_ sender: UIButton) {
        helper.connectQuoteServer()
    }
    
    @IBAction func pushButtonDidTapped(_ sender: UIButton) {
        helper.connectPushServer()
    }
    
    @IBAction func tradeButtonDidTapped(_ sender: UIButton) {
        helper.connectTradeServer()
    }
    
    @IBAction func connectAllButtonDidTapped(_ sender: UIButton) {
    }
    
    @IBAction func disconnectAllButtonDidTapped(_ sender: UIButton) {
    }
    
}
