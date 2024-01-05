//
//  Book.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/4.
//

import Foundation

struct BookData: Codable {
    var total: Int
    var items: [Book]
}

struct Book: Codable, Identifiable {
    var id = UUID()
    var isbn: String
    var title: String
    var author: String
    var publisher: String
    var publishdate: String
    var copies: Int
    var librarianNumber: String
    var bookCover: String?
    
    private enum CodingKeys: String, CodingKey {
        case isbn, title, author, publisher, publishdate, copies, librarianNumber, bookCover
    }
}
