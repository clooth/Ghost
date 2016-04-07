//
//  AuthWebViewController.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 07/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import OAuthSwift
import UIKit
import WebKit

class AuthWebViewController: OAuthWebViewController, WKNavigationDelegate {
  var targetURL = NSURL()
  var webView = WKWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    webView.frame = view.bounds
    webView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
    webView.navigationDelegate = self
    view.addSubview(webView)
  }
  
  override func handle(url: NSURL) {
    targetURL = url
    super.handle(url)
    beginLoadURL()
  }
  
  func beginLoadURL() {
    let request = NSURLRequest(URL: self.targetURL)
    webView.loadRequest(request)
  }
  
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
    let app = UIApplication.sharedApplication()
    if let url = navigationAction.request.URL where url.scheme == "io.sizeof.ghost" {
      app.openURL(url)
      decisionHandler(.Cancel)
      self.dismissWebViewController()
      return
    }
    decisionHandler(.Allow)
  }
}