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
    
    var webView: WKWebView!
    var qiitaArticleUrl: String!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let qiitaUrl = qiitaArticleUrl {
            if let qiitaRecUrl = URL(string: qiitaUrl){
                let myRequest = URLRequest(url: qiitaRecUrl)
                webView.load(myRequest)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "back") {
            let backToVC = segue.destination as? ViewController
        }
    }
}
