//
//  TopViewController.swift
//  Runner
//
//  Created by code0 on 2022/06/25.
//

import UIKit
import Flutter

class TopViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func onTapped(_ sender: UIButton) {
        let flutterEngine = (UIApplication.shared.delegate as! AppDelegate).flutterEngine
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        let channel = FlutterMethodChannel(name: "channel",
                                                  binaryMessenger: flutterViewController.binaryMessenger)
        channel.invokeMethod("setup", arguments: nil)
        
        flutterViewController.modalPresentationStyle = .fullScreen
        flutterViewController.loadDefaultSplashScreenView()
        present(flutterViewController, animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Native Top"
    }
}
