//
//  ViewController.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 03/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import UIKit
import Bond
import RealmSwift

class ViewController: UITableViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "+ Google", style: UIBarButtonItemStyle.Done, target: self, action: "addGoogleAccount")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  func addGoogleAccount() {
    let googleAuth = GhostGoogleAuth()
    googleAuth.authenticate { account in
      guard let account = account else {
        print("Account not found.")
        return
      }
      
      account.save()
      print("Authenticated google account: \(account.username)")
    }
  }
}