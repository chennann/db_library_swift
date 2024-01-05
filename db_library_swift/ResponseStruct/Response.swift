//
//  Response.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/4.
//

import Foundation


struct Response<T: Codable>: Codable {
    var code: Int
    var message: String
    var data: T
}
