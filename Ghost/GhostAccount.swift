//
//  GhostAccount.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 07/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import RealmSwift
import Locksmith
import OAuthSwift

/// A single email account in ghost
class GhostAccount: Object {
  /// The username of the account
  dynamic var username: String = ""
  
  /// The password or OAuth2 access token of the account
  dynamic var password: String? {
    get {
      guard let info = Locksmith.loadDataForUserAccount(username) else {
        return nil
      }
      guard let password = info["password"] as? String else {
        return nil
      }
      return password
    }
    
    set(newValue) {
      guard let newValue = newValue else {
        return
      }
      
      if let _ = Locksmith.loadDataForUserAccount(username) {
        try! Locksmith.updateData(["password": newValue], forUserAccount: username)
        print("Updated password for account: \(username)")
      }
      else {
        try! Locksmith.saveData(["password": newValue], forUserAccount: username)
        print("Stored password for account: \(username)")
      }
    }
  }
  
  /// Whether the account is behind OAuth2
  dynamic var isOAuth2: Bool = false
  
  /// The hostname of the mail server
  dynamic var hostname: String = ""
  
  /// The port of the mail server
  dynamic var port: Int = 993
  
  /// Don't store the password in realm
  override static func ignoredProperties() -> [String] {
    return ["password"]
  }
  
  override static func primaryKey() -> String? {
    return "username"
  }
}

extension GhostAccount {
  func save() {
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "Ghost"))
    try! realm.write {
      realm.add(self, update: true)
    }
  }
}