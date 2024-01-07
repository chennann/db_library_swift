//
//  NetworkService.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/4.
//

import Foundation


import Foundation
import UIKit

class NetworkService {
    
    func saveRole (_ role : String) {
        UserDefaults.standard.set(role, forKey: "role")
    }
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func printRequestDetails(request: URLRequest) {
        if let url = request.url {
            print("URL: \(url)")
        }
        
        if let method = request.httpMethod {
            print("Method: \(method)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    func librarianLogin(librarianNumber: String, name: String, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8443/librarian/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestBody = "librarianNumber=\(librarianNumber)&name=\(name)"
        request.httpBody = requestBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func readerLogin(readerId: String, password: String, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8443/reader/login") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let requestBody = "readerId=\(readerId)&password=\(password)"
        request.httpBody = requestBody.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func findBooks(pageNum: Int, pageSize: Int, title: String?, author: String?, isbn: String?, completion: @escaping (Result<Response<BookData>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8443/book/find") else { return }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "pageNum", value: String(pageNum)),
//            URLQueryItem(name: "pageSize", value: String(pageSize)),
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "author", value: author),
//            URLQueryItem(name: "isbn", value: isbn)
//        ]
        var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "pageNum", value: String(pageNum)),
                URLQueryItem(name: "pageSize", value: String(pageSize))
            ]
            
            if let title = title {
                queryItems.append(URLQueryItem(name: "title", value: title))
            }
            
            if let author = author {
                queryItems.append(URLQueryItem(name: "author", value: author))
            }

            if let isbn = isbn {
                queryItems.append(URLQueryItem(name: "isbn", value: isbn))
            }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<BookData>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func bookcopyListService (pageNum: Int, pageSize: Int, title: String?, completion: @escaping (Result<Response<BookCopiesData>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8443/copies/findcopies") else { return }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "pageNum", value: String(pageNum)),
//            URLQueryItem(name: "pageSize", value: String(pageSize)),
//            URLQueryItem(name: "title", value: title),
//            URLQueryItem(name: "author", value: author),
//            URLQueryItem(name: "isbn", value: isbn)
//        ]
        var queryItems: [URLQueryItem] = [
                URLQueryItem(name: "pageNum", value: String(pageNum)),
                URLQueryItem(name: "pageSize", value: String(pageSize))
            ]
            
            if let title = title {
                queryItems.append(URLQueryItem(name: "bookName", value: title))
            }
            
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<BookCopiesData>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("JSON Decode Error: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func allocateService (bookId: String, To: String, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8443/copies/allocate") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = allocateStruct(bookId: bookId, location: To)
            do {
                let jsonData = try JSONEncoder().encode(loginData)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func bookPrecheckService (isbn: String, completion: @escaping (Result<Response<Book>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8443/book/add/precheck") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = precheckStruct(isbn: isbn)
            do {
                let jsonData = try JSONEncoder().encode(loginData)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }
        
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            
            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<Book>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                
                let defaultBook = Book(isbn: isbn, title: "", author: "", publisher: "", publishdate: "", copies: 1, librarianNumber: "", isNewBook: true)
                let newBookResponse = Response<Book>(code: 0, message: error.localizedDescription, data: defaultBook)
                DispatchQueue.main.async {
                    completion(.success(newBookResponse))
                }
//                completion(.failure(error))
            }
        }.resume()
    }
    
    func compressImageTo1MB(_ image: UIImage) -> Data? {
        var compressionQuality: CGFloat = 1.0
        let maxFileSize = 100_000 // 1MB 的大小
        var imageData = image.jpegData(compressionQuality: compressionQuality)

        while (imageData?.count ?? 0) > maxFileSize && compressionQuality > 0 {
            compressionQuality -= 0.1
            imageData = image.jpegData(compressionQuality: compressionQuality)
        }

        return imageData
    }
    
    func uploadFile(image: UIImage, completion: @escaping (Result<Response<String?>, Error>) -> Void) {
        guard let url = URL(string: "https://47.115.229.197:8443/upload") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

//        guard let imageData = image.jpegData(compressionQuality: 1.0) ?? image.pngData() else {
//            completion(.failure(URLError(.badURL)))
//            return
//        }
        guard let imageData = compressImageTo1MB(image) else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var body = Data()

        // 文件部分
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(imageData)
        body.append("\r\n")

        // 请求结束标志
        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        // 如果需要，添加其他 HTTP 头部
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }

        printRequestDetails(request: request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            // 新增：打印返回的原始数据
            let dataString = String(data: data, encoding: .utf8)
            print("Received data: \(dataString ?? "No data")")
            
            do {
                let decodedResponse = try JSONDecoder().decode(Response<String?>.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }



}

