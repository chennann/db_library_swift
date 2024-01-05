//
//  NetworkService.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/4.
//

import Foundation


import Foundation

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
    
    func findBooks(pageNum: Int, pageSize: Int, title: String, completion: @escaping (Result<Response<BookData>, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: "https://47.115.229.197:8443/book/find") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "pageNum", value: String(pageNum)),
            URLQueryItem(name: "pageSize", value: String(pageSize)),
            URLQueryItem(name: "title", value: title)
        ]
        
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
    
    
}

