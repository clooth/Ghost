//
//  GhostGoogleAuth.swift
//  Ghost
//
//  Created by Nico Hämäläinen on 07/03/16.
//  Copyright © 2016 sizeof.io. All rights reserved.
//

import Foundation
import OAuthSwift
import SwiftyJSON

class GhostGoogleAuth {
  // OAuth Object
  lazy var oauth: OAuth2Swift = OAuth2Swift(
    consumerKey: "714617934396-9hu5tqufn7u27amquugkud6ves84v594.apps.googleusercontent.com",
    consumerSecret: "",
    authorizeUrl: "https://accounts.google.com/o/oauth2/v2/auth",
    accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
    responseType: "code"
  )
  
  var credentials: OAuthSwiftCredential?
  var oauthParameters: [String: String]?
  
  init() {
    let webView = AuthWebViewController()
    oauth.authorize_url_handler = webView
  }
  
  func authenticate(callback: (account: GhostAccount?) -> Void) {
    oauth.authorizeWithCallbackURL(
      NSURL(string: "io.sizeof.ghost:/oauth-callback")!,
      scope: "https://mail.google.com/ email profile",
      state: "test",
      success: { credential, response, parameters in
        self.credentials = credential
        self.oauthParameters = parameters
        self.requestUserInformation(callback)
      },
      failure: { error in
        print(error)
      }
    )
  }
  
  func requestUserInformation(callback: (account: GhostAccount?) -> Void) {
    guard let params = self.oauthParameters else {
      return callback(account: nil)
    }
    
    guard let credentials = self.credentials else {
      return callback(account: nil)
    }
    
    guard let idToken = params["id_token"] else {
      return callback(account: nil)
    }
    
    // Google token info
    let url = "https://www.googleapis.com/oauth2/v1/tokeninfo?id_token=\(idToken)"
    
    // Fetch user profile information
    oauth.client.get(
      url,
      success: { data, response in
        // Get JSON
        let json = JSON(data: data)
        
        // Get properties
        guard let email = json["email"].string else {
          print("Email address not found in response.")
          callback(account: nil)
          return
        }
        
        let account = GhostAccount()
        account.username = email
        account.password = credentials.oauth_token
        account.hostname = "imap.google.com"
        account.port = 993
        account.isOAuth2 = true
        callback(account: account)
      },
      failure: { error in
        print("Error fetching user information")
        print(error.localizedDescription)
        callback(account: nil)
      }
    )
  }
}