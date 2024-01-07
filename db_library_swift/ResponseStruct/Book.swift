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

//struct precheckedBook: Codable, Identifiable {
//    var id = UUID()
//    var isbn: String
//    var title: String
//    var author: String
//    var publisher: String
//    var publishdate: String
//    var copies: Int
//    var librarianNumber: String
//    var bookCover: String?
//    var isNewBook: Bool = false
//
//    private enum CodingKeys: String, CodingKey {
//        case isbn, title, author, publisher, publishdate, copies, librarianNumber, bookCover
//    }
//}

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
    var isNewBook: Bool = false
    var isCameraPresented: Bool = false
    
    var Pdate: Date {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.date(from: publishdate) ?? Date()
        }
        set {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            publishdate = dateFormatter.string(from: newValue)
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case isbn, title, author, publisher, publishdate, copies, librarianNumber, bookCover
    }
}


struct BookCopiesData: Codable {
    var total: Int
    var items: [BookCopy]
}

struct BookCopy: Codable, Identifiable {
    var id = UUID()
    var title: String
    var bookId: String
    var isbn: String
    var location: String
    var status: String
    var librarianNumber: String
    
    private enum CodingKeys: String, CodingKey {
        case title, bookId, isbn, location, status, librarianNumber
    }
}

