//
//  SecondViewController.swift
//  qiitAPI
//
//  Created by ishikawa on 2020/02/19.
//  Copyright © 2020 ishikawa. All rights reserved.
//

import UIKit
import WebKit

class SecondViewController: UIViewController,WKUIDelegate {
    
    var qiitaArticleUrl: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let qiitaUrl = qiitaArticleUrl {
            if let qiitaRecUrl = URL(string: qiitaUrl){
                let myRequest = URLRequest(url: qiitaRecUrl)
                webView.load(myRequest)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
