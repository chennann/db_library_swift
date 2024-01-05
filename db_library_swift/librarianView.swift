//
//  bookView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/5.
//

import SwiftUI

struct librarianView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        TabView {
            // MARK: - 图书
//            VStack {
//                Text("LLLLLLView")
//                Text(loginManager.token)
//                Text(loginManager.role)
//                Button {
//                    logout()
//                } label: {
//                    Text("logout")
//                }
//
//            }
            librarianBookView()
            .tabItem {
                Image(systemName: "books.vertical.fill")
                Text("图书")
            }
            // MARK: - 新书入库
            StorageView()
                .tabItem {
                    Image(systemName: "tray.and.arrow.down")
                    Text("新书入库")
                }
        }
    }
    
    
    func logout () {
        loginManager.isLoggedIn  = false
        loginManager.token = ""
        loginManager.role = ""
    }
}



#Preview {
    librarianView()
        .environmentObject(LoginManager())
}
