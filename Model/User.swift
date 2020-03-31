//
//  User.swift
//  FirebaseAplha
//
//  Created by Arvydas Klimavicius on 2020-03-31.
//  Copyright © 2020 Arvydas Klimavicius. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String = ""
    var username: String = ""
    var avatarUrl: String = ""
    var hasSetupAccount: Bool = false
    var isGuest: Bool = false
}
