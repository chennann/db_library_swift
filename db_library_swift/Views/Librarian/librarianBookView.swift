//
//  librarianBookView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI

struct librarianBookView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var sharedModel: SharedModel
    
    @StateObject private var keyboardManager = KeyboardManager()
    
    @State private var books: [Book] = []
    @State private var loginResponse: Response<String?>?
    @State private var errorMessage: String?
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var isbn: String = ""
    
    @State var isloading: Bool = false
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                VStack {
                    if isloading {
                        ProgressView()
                    }
                    else {
                        HStack {
                            Text("图书列表：")
                                .bold()
                                .font(.system(size: 30))
                            Spacer()
                        }
                        .padding(.horizontal)
                        .offset(y:books.isEmpty ? -220 : 0)
                        
                        if !books.isEmpty {
                            List(books) { book in
                                NavigationLink  {
                                    BookDetailView(title: book.title, isbn: book.isbn)
                                } label: {
                                    HStack {
                                        AsyncImage(url: URL(string: book.bookCover ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/d9f704a4-9166-463b-943b-cb0558838c5d.jpg")) { image in
                                                    image.resizable()
                                                         .aspectRatio(contentMode: .fit)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(width: 100, height: 100)
                                        VStack(alignment: .leading) {
                                            Text("《\(book.title)》").font(.headline)
                                            Text("作者：\(book.author)").font(.subheadline)
                                            Text("\(book.isbn)").font(.caption)
                                                .italic()
                                                .foregroundColor(Color.gray)
                                        }
                                    }
                                }
                                .navigationBarBackButtonHidden(true)
                                
                                
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
                    
                }
                .frame(height: 700)
            
                VStack {
                    HStack {
                        Text("查询条件：")
                            .bold()
                            .font(.system(size: 25))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 筛选条件输入框
                    HStack (spacing: 0) {
                        Text("标题： ")
                        TextField("Title", text: $title)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    HStack (spacing: 0) {
                        Text("作者： ")
                        TextField("Author", text: $author)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    HStack (spacing: 0) {
                        Text("ISBN： ")
                        TextField("ISBN", text: $isbn)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    
                    HStack (spacing: 0) {
                        Button(action: {
                            searchBooks()
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                                .frame(width: 150, height: 50)
                                .overlay {
                                    Text("搜索")
                                        .foregroundColor(Color.white)
                                        .bold()
                                        .font(.system(size: 18))
                                }
                            
                        })
                        
                        Spacer()
                        Button(action: {
                            clearCondition()
                            searchBooks()
                        }, label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray)
                                .frame(width: 150, height: 50)
                                .overlay {
                                    Text("重置")
                                        .foregroundColor(Color.white)
                                        .bold()
                                        .font(.system(size: 18))
                                }
                        })
                    }
                    .padding(.horizontal, 35)
                    .padding(.top, 22)
                }
                .background(
                    RoundedRectangle(cornerRadius: 15) // 设置圆角半径
                        .fill(Color.white) // 设置填充颜色
                        .shadow(radius: 10) // 可选的，添加阴影效果
                        .frame(height: 300)
                    
                )
                .padding(.top, sharedModel.showSearchBar ? 280 : -300) // 初始状态在屏幕外
                .transition(.move(edge: .top)) // 从上方移入
    //            .animation(.spring(response: 0.5, dampingFraction: 0.85, blendDuration: 0)) // 使用弹簧动画
                .animation(.easeOut(duration: 0.4))
                .frame(width: geometry.size.width)
                .position(x: geometry.size.width / 2, y: 0) // 固定在屏幕顶部
                
            }
            .onAppear(perform: {
                searchBooks()
//                doNothing()
            })
            .frame(minHeight: geometry.size.height)
            .offset(y: keyboardManager.keyboardHeight>0 ? 100 : 0)
            

        }
        
        
    }
    
    
    func doNothing () {
        
    }
    
    func clearCondition () {
        title = ""
        author = ""
        isbn = ""
    }
    
    func searchBooks () {
        
        withAnimation(nil) {
            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.findBooks(pageNum: 1, pageSize: 10, title: title.isEmpty ? nil : title, author: author.isEmpty ? nil : author, isbn: isbn.isEmpty ? nil : isbn) { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                self.books = response.data.items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
        
        withAnimation {
            sharedModel.showSearchBar = false
        }
    }
}

#Preview {
    librarianBookView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
