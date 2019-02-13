//
//  LaarcUserData.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/12/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let LOGIN_URL = "https://www.laarc.io/login"

class LaarcUserData {
    static let shared = LaarcUserData()

    private let _defaults = UserDefaults.standard
    
    private init() {}

    func isUserLoggedIn() -> Bool {
        if let cookies = Alamofire.SessionManager.default.session.configuration.httpCookieStorage?.cookies {
            if let _ = cookies.first(where: { $0.name == "user" }) {
                return true
            }
        }
        return false
    }

    func loginUser(username: String, password: String) {
        if let url = URL(string: LOGIN_URL) {
            let params: Parameters = [
                "acct": username,
                "pw": password
            ]
            let request = Alamofire.request(url, method: .post, parameters: params, headers: nil)
            request.response() { response in
                if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
                    print(cookies)
                }
            }
        }
    }
}
