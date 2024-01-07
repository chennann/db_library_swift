//
//  LoginView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/5.
//

import SwiftUI

struct LoginView: View {
    //    @Binding var isLoggedIn: Bool
    @EnvironmentObject var loginManager: LoginManager
    
    @State private var loginResponse: Response<String?>?
    @State private var errorMessage: String?
    
    @State private var lNumber: String = ""
    @State private var lName: String = ""
    @State private var rId: String = ""
    @State private var rPwd: String = ""
    
    @State var showPassword: Bool = false
    @State var librarianLogin: Bool = false
    @State var isloading: Bool = false
    
    @State var str: String = ""
    var body: some View {
        
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color.orange, Color.red]), center: .topTrailing, startRadius: 80, endRadius: 600)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    if librarianLogin {
                        Text("管理员")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    else {
                        Text("读者")
                            .font(.system(size: 60))
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                }
                .frame(width: 300)
                
                
                if librarianLogin {
                    //MARK: - 管理员登录
                    VStack (spacing: 20) {
                        TextField("librarianNumber", text: $lNumber)
                            .frame(width: 320, height: 25)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding()
                        
                        
                        TextField("librarianName", text: $lName)
                            .frame(width: 320, height: 25)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                        
                        
                        
                        
                        
                        
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 30)
                }
                else {
                    //MARK: - 读者登录
                    VStack (spacing: 20) {
                        TextField("readerId", text: $rId)
                            .frame(width: 320, height: 25)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 8)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(8)
                            .padding()
                        ZStack(alignment: .trailing) {
                            if showPassword {
                                TextField("password", text: $rPwd)
                                    .frame(width: 320, height: 25)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(8)
                            } else {
                                SecureField("password", text: $rPwd)
                                    .frame(width: 320, height: 25)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.9))
                                    .cornerRadius(8)
                                
                            }
                            
                            Button(action: {
                                showPassword.toggle()
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(showPassword ? .gray : .gray)
                            }
                            .padding(.trailing, 10)
                        }
                        
                        
                        
                        
                    }
                    .padding(.horizontal, 50)
                    .padding(.vertical, 30)
                }
                
                
                //                if let response = loginResponse {
                //                    Text("Code: \(response.code)")
                //                    Text("Message: \(response.message)")
                //                    Text("Data: \(response.data ?? "")")
                //                } else if let errorMessage = errorMessage {
                //                    Text("Error: \(errorMessage)")
                //                }
                Text(str)
                
                Button(action : {
                    librarianLogin.toggle()
                }) {
                    
                    HStack {
                        if librarianLogin {
                            
                            
                            Spacer()
                            Text("← 读者登陆")
                                .foregroundColor(.black)
                            
                            
                        }
                        else {
                            
                            Text("管理员登陆 →")
                                .foregroundColor(.black)
                            Spacer()
                            
                        }
                    }
                    .frame(width: 300)
                    .padding(.bottom)
                    
                    
                }
                
                Button(action: {
                    withAnimation(nil) {
                        isloading = true
                    }
                    
                    let networkService = NetworkService()
                    if librarianLogin {
                        networkService.librarianLogin(librarianNumber: lNumber, name: lName) { result in
                            defer { isloading = false }
                            switch result {
                            case .success(let response):
                                self.loginResponse = response
                                
                                if response.code == 0 {
                                    loginManager.token = response.data ?? ""
                                    loginManager.role = "librarian"
                                    loginManager.isLoggedIn.toggle()
                                }
                                else {
                                    str = response.message
                                }
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                    else {
                        networkService.readerLogin(readerId: rId, password: rPwd) { result in
                            defer { isloading = false }
                            switch result {
                            case .success(let response):
                                self.loginResponse = response
                                if response.code == 0 {
                                    loginManager.token = response.data ?? ""
                                    loginManager.role = "reader"
                                    loginManager.isLoggedIn.toggle()
                                }
                                else {
                                    str = response.message
                                }
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    }
                    
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                        .frame(width: 200, height: 50)
                        .overlay (
                            HStack (spacing: 15) {
                                if isloading {
                                    Text("登录中...")
                                        .foregroundColor(Color.black)
                                        .bold()
                                        .font(.system(size: 20))
                                    ProgressView()
                                }
                                else {
                                    Text("登录")
                                        .foregroundColor(Color.black)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        )
                    
                }
                .frame(width: 200)
                
                //                if let response = loginResponse {
                //                    Text("Code: \(response.code)")
                //                    Text("Message: \(response.message)")
                //                    Text("Data: \(response.data)")
                //                } else if let errorMessage = errorMessage {
                //                    Text("Error: \(errorMessage)")
                //                }
                //
                //                Text(UserDefaults.standard.string(forKey: "role") ?? "未登录")
            }
            .padding()
        }
    }
}


#Preview {
    
    LoginView()
        .environmentObject(LoginManager())
}
