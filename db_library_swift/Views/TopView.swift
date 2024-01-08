//
//  TopView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI

struct TopView: View {
    
    @EnvironmentObject var sharedModel: SharedModel
    @EnvironmentObject var loginManager: LoginManager
    
    @State private var showUser = false
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            Text("图书管理")
                .foregroundColor(Color.white)
                .font(.title)
                .bold()
                .italic()
            HStack {
                Button (action:{
                    withAnimation {
                        sharedModel.showSearchBar.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .bold()
                        .foregroundColor(Color.white)
                }
                Spacer()
                Button (action:{
                    showUser = true;
                }) {
                    
                    if (loginManager.role == "librarian") {
                        Image(systemName: "person.badge.key.fill")
                            .font(.system(size: 30))
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding(.trailing, 5)
                    }
                    else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 30))
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.white.opacity(0.6))
                            .padding(.trailing, 5)
                    }
                    
                    
                }
                .sheet(isPresented: $showUser) {
                    ProfileView()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
        .background(Color("Top_color"))
    }
}

#Preview {
    TopView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
