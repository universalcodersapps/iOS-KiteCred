//
//  NewsWebViewController.swift
//  Kite
//
//  Created by Dileep Jaiswal on 17/04/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewController: UIViewController {
    
    var webViewUrl = ""
    var webView: WKWebView!

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: webViewUrl)!
        DispatchQueue.main.async {
            Spinner.start()
        }
        setToolBar()
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
           DispatchQueue.main.async {
               Spinner.stop()
           }
        }
    }
    
    fileprivate func setToolBar() {
        let screenWidth = self.view.bounds.width
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [backButton]
        webView.addSubview(toolBar)
    // Constraints
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
      }
    
      @objc private func goBack() {
        self.navigationController?.popViewController(animated: true)
      }
    
}

extension NewsWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started to load")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
        DispatchQueue.main.async {
            Spinner.stop()
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        DispatchQueue.main.async {
            Spinner.stop()
        }
    }
    
    @available(iOS 13.0, *)
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        preferences.preferredContentMode = .mobile
        decisionHandler(.allow, preferences)
    }
}
