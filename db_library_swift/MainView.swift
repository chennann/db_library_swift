//
//  MainView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/5.
//

import SwiftUI

struct MainView: View {
    
    init() {
        let appeareance = UITabBarAppearance()
        
            // 设置Tab栏的外观
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
//        UITabBar.appearance().backgroundColor = UIColor(red: 230/255.0, green: 229/255.0, blue: 230/255.0, alpha: 1.0)
        UITabBar.appearance().backgroundColor = UIColor(Color("tab_background").opacity(0.7))
        appeareance.shadowColor = UIColor(Color.black)
        //未选中的标签的气泡的位置
        


        }
    
//    @State private var isLoggedIn = false
    @EnvironmentObject var loginManager: LoginManager

    var body: some View {
        if loginManager.isLoggedIn {
            if loginManager.role == "librarian" {
                librarianView()
            }
            else {
                readerView()
            }
        }
        else {
            LoginView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LoginManager())
}
