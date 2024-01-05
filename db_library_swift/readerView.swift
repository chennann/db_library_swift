//
//  readerView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/5.
//

import SwiftUI

struct readerView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        TabView {
            // MARK: - 图书
//            VStack {
//                Text("RRRRRRView")
//                Text(loginManager.token)
//                Text(loginManager.role)
//                Button {
//                    logout()
//                } label: {
//                    Text("logout")
//                }
//
//            }
            ReaderBookView()
                .tabItem {
                    VStack {
                        Image(systemName: "books.vertical.fill")
                        Text("图书")
                    }
                    
            }
            // MARK: - 借阅记录
            BorrowView()
                .tabItem {
                    Image(systemName: "doc.text")
                    Text("借阅")
                }
            // MARK: - 预约记录
            ReservationView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("预约")
                }
            // MARK: - 收件箱
            InboxView()
                .tabItem {
                    Image(systemName: "tray")
                    Text("收件箱")
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
    readerView()
        .environmentObject(LoginManager())
}
