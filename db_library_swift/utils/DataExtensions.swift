//
//  DataExtensions.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/8.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
    var mimeType: String {
        let ext = self.pathExtension.lowercased()
        let utType = UTType(filenameExtension: ext)
        return utType?.preferredMIMEType ?? "application/octet-stream"
    }
}




extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
