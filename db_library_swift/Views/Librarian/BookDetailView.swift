//
//  BookDetailView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI

struct BookDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var bookcopies: [BookCopy] = []
    @State private var errorMessage: String?
    
    @State var isloading: Bool = false
    
    @State var qweqwe: String = ""
    
    var title:String = ""
    var isbn:String = ""
    
    @State var selection: String = "asd"
    @State private var selectedLocations: [String: String] = [:] // 用于存储每本书的选定位置
    let locations: [String] = ["图书阅览室", "图书流通室"] // 可选的位置列表
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color.orange)
                            .font(.system(size: 23, weight: .bold))
                    })
                    Spacer()
                }
                Text("《\(title)》")
                    .bold()
                    .font(.system(size: 30))
            }
            .padding(.horizontal)
            if !bookcopies.isEmpty {
                List(bookcopies) { book in
                    
                    let bookId = book.bookId // 确保这是直接访问的属性
                    let binding = Binding<String>(
                        get: { self.selectedLocations[bookId, default: book.location] },
                        set: { self.selectedLocations[bookId] = $0 }
                    )
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("书本ID：\(book.bookId)").font(.headline)
                            Text("\(book.isbn)").font(.caption)
                                .italic()
                                .foregroundColor(Color.gray)
                        }
                        
                        Picker(selection: binding,
                               label:
                                HStack {
                            Text("asd:")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        },
                               content: {
                            ForEach (locations, id: \.self) { option in
                                Text(option)
                                    .tag(option)
                            }
                        })
                    }
                    .onChange(of: selectedLocations[bookId] ?? "") { newValue in
                        allocate(bookId: bookId, newLocation: newValue)
                    }
                    
                    
                }
                .onAppear {
                    // 初始化每本书的位置
                    for book in bookcopies {
                        selectedLocations[book.bookId] = book.location
                    }
                }
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 200))
                    .bold()
                    .foregroundColor(Color.gray)
            }
            
            
            
        }
        .onAppear(perform: {
            bookcopyList()
        })
        
    }
    
    func bookcopyList () {
        withAnimation(nil) {
            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.bookcopyListService(pageNum: 1, pageSize: 100, title: title.isEmpty ? nil : title) { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                self.bookcopies = response.data.items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func allocate (bookId: String, newLocation: String) {
        let networkService = NetworkService()
        networkService.allocateService(bookId: bookId, To: newLocation) { result in
//            defer { bookcopyList() }
            switch result {
            case .success(_):
                bookcopyList()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    BookDetailView(title: "一本书", isbn: "ISBN7-304-02368-9" )
}
