//
//  librarianBookView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI

struct librarianBookView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        
        VStack {
            Text("librarianBook")
            
            
            VStack {
                Text("LLLLLLView")
                Text(loginManager.token)
                Text(loginManager.role)
                Button {
                    logout()
                } label: {
                    Text("logout")
                }
                
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
    librarianBookView()
        .environmentObject(LoginManager())
}
