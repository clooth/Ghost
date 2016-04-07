//
//  NewAccountViewController.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 07/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import Eureka

class NewAccountViewController: FormViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Accounts"
    
    let ghost = Ghost.instance
    let accounts = ghost.accounts()
    
    // Accounts list elements
    form +++= Section("Accounts")
    for account in accounts {
      form.last! <<< LabelRow() {
        $0.title = account.username
        $0.value = account.hostname
      }
    }
    
    let accountTypes = ["Google", "IMAP", "Outlook"]
    
    // New account elements
    form +++= Section("Add New Account")
      <<< SegmentedRow<String>("new_account_type") {
        $0.options = accountTypes
      }
    
    form +++= Section("New Google Account") {
      $0.hidden = "$new_account_type != 'Google'"
      }
      <<< ButtonRow() {
        $0.title = "Sign in with Google"
        $0.onCellSelection { cell, row in
          let auth = GhostGoogleAuth()
          auth.authenticate { account in
            print(account)
            account?.save()
          }
        }
      }.onChange { row in
        print("tap")
      }
    
    form +++= Section("New IMAP Account") {
      $0.hidden = "$new_account_type != 'IMAP'"
      }
      <<< EmailRow() {
        $0.title = "Email Address"
      }
      <<< PasswordRow() {
        $0.title = "Password"
        $0.placeholder = "Required"
      }
      <<< TextRow() {
        $0.title = "Description"
        $0.placeholder = "My Email Account"
      }
      <<< ButtonRow() {
        $0.title = "Add Account"
      }
    
    form +++= Section("New Outlook Account") {
      $0.hidden = "$new_account_type != 'Outlook'"
      }
      <<< EmailRow() {
        $0.title = "Email Address"
        $0.placeholder = "email@outlook.com"
      }
      <<< PasswordRow() {
        $0.title = "Password"
        $0.placeholder = "Required"
      }
      <<< TextRow() {
        $0.title = "Description"
        $0.placeholder = "My Outlook Account"
      }
      <<< ButtonRow() {
        $0.title = "Add Account"
      }
  }
  
}