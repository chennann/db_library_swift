//
//  SendStruct.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import Foundation
import Combine

struct allocateStruct: Codable {
    var bookId: String
    var location: String
}

struct precheckStruct: Codable {
    var isbn: String
}

class increaseBook: ObservableObject {
    var isbn: String
    @Published var count: Int

    init(isbn: String, count: Int) {
        self.isbn = isbn
        self.count = count
    }
}
