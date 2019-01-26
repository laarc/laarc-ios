//
//  LaarcData.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 1/26/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation

class LaarcData {
    static let shared = LaarcData()
    
    var comments = [LaarcComment]()

    private init() {
        
    }
}
