//
//  AppDelegate.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 03/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import UIKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    return true
  }
  
  func applicationHandleOpenURL(url: NSURL) {
    OAuthSwift.handleOpenURL(url)
  }
}

extension AppDelegate {
  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    applicationHandleOpenURL(url)
    return true
  }
  
  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
    applicationHandleOpenURL(url)
    return true
  }
}

