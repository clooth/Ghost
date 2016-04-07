//
//  Ghost.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 03/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import RealmSwift

class Ghost {
  static let instance = Ghost()

  var realm = try! Realm.init(configuration: Realm.Configuration(inMemoryIdentifier: "Ghost"))
  
  init() {
  }
  
  func accounts() -> [GhostAccount] {
    return realm.objects(GhostAccount).map({ $0 })
  }
}