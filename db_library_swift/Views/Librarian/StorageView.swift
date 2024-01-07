//
//  StorageView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI
import Vision

struct StorageView: View {
    //这个字符串数组是为了存放获取的文本
    @State var textStrings = [String]()
    //这个name用来指定使用哪个图像，如果想用其他图像修改这个变量就行
    @State var name = "info"
    
    
    @State private var showCamera = false
    @State var image: UIImage?
    
    
    @State var progress: Int = 0
    @State var colorNum: Int = 0
    
    @State var currentStep = 1
    let steps = ["扫描ISBN", "完善信息", "完成"]
    
    @State var ISBNs: [String] = ["ISBN7-305-02368-9", "ISBN7-377-02368-9", "ISBN7-389-02368-9"]
    //    @State var ISBNs: [String] = []
    //    @State var increaseNum: [Int] = [1, 2, 3]
    
    @State var Books: [Book] = []
//    @State var Books: [Book] = [
//        Book(isbn: "", title: "qqq", author: "", publisher: "", publishdate: "", copies: 0, librarianNumber: "", isNewBook: true),
//        Book(isbn: "", title: "www", author: "", publisher: "", publishdate: "", copies: 0, librarianNumber: "", isNewBook: true),
//        Book(isbn: "", title: "eee", author: "", publisher: "", publishdate: "", copies: 0, librarianNumber: "", isNewBook: true)]
    @State var receivBook: Book = Book(isbn: "", title: "", author: "", publisher: "", publishdate: "", copies: 0, librarianNumber: "")
    @State private var errorMessage: String?
    var body: some View {
        
        VStack {
            ZStack {
                if currentStep == 1 || ISBNs.isEmpty {
                    VStack {
                        Button {
                            self.showCamera = true
                        } label: {
                            Image(systemName: "camera")
                                .font(.system(size: 200))
                                .bold()
                                .foregroundColor(Color.gray)
                        }
                        Button {
                            self.showCamera = true
                        } label: {
                            Text("手动输入ISBN")
                        }
                        .padding()
                    }
                    .fullScreenCover(isPresented: $showCamera) {
                        CameraView(image: self.$image)
                            .onDisappear(perform: {
                                textRecg()
                            })
                    }
                }
                else if currentStep == 2 {
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(Books.indices, id: \.self) { index in
                                VStack {
                                    HStack {
                                        Text("书名: ")
                                        TextField("ISBN", text: $Books[index].title)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .disabled(!Books[index].isNewBook)
                                    }
                                    .padding(10)
                                    HStack {
                                        Text("ISBN: ")
                                        TextField("ISBN", text: $Books[index].isbn)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                            .disabled(true)
                                    }
                                    .padding(10)
                                    HStack {
                                        DatePicker("发布日期:", selection: $Books[index].Pdate, displayedComponents: .date)
                                            .disabled(!Books[index].isNewBook)
                                        Spacer(minLength: 60)
                                    }
                                    .padding(10)
                                    
                                    HStack {
                                        VStack {
                                            HStack {
                                                Text("作者: ")
                                                TextField("ISBN", text: $Books[index].author)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .disabled(!Books[index].isNewBook)
                                            }
                                            .padding(10)
                                            HStack {
                                                Text("发行商: ")
                                                TextField("ISBN", text: $Books[index].publisher)
                                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                                    .disabled(!Books[index].isNewBook)
                                            }
                                            .padding(10)
                                            HStack {
                                                
                                                Stepper("册数： \(Books[index].copies)", value: $Books[index].copies)
                                            }
                                            .padding(10)
                                            
                                        }
                                        Button {
                                            Books[index].isCameraPresented = true
                                        } label: {
                                            AsyncImage(url: URL(string: Books[index].bookCover ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/d9f704a4-9166-463b-943b-cb0558838c5d.jpg")) { image in
                                                        image.resizable()
                                                             .aspectRatio(contentMode: .fit)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 150, height: 150)
                                        }
                                        .disabled(!Books[index].isNewBook)

                                    }
                                    .fullScreenCover(isPresented: $Books[index].isCameraPresented) {
                                        CameraView(image: self.$image)
                                            .onDisappear(perform: {
                                                let networkService = NetworkService()
                                                networkService.uploadFile(image: image ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                    switch result {
                                                    case .success(let response):
                                                        Books[index].bookCover = response.data
                                                    case .failure(let error):
                                                        self.errorMessage = error.localizedDescription
                                                    }
                                                }
                                                Books[index].isCameraPresented = false
                                            })
                                    }
                                    
                                    HStack {
                                        Button {
                                            
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.blue)
                                                .frame(width: 150, height: 50)
                                                .overlay {
                                                    Text("Add")
                                                        .foregroundColor(Color.white)
                                                        .bold()
                                                        .font(.system(size: 18))
                                                }
                                        }
                                        Spacer()
                                        Button {
                                        
                                                Books.remove(at: index)
                                            
                                        } label: {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.red)
                                                .frame(width: 150, height: 50)
                                                .overlay {
                                                    Text("Cancel")
                                                        .foregroundColor(Color.white)
                                                        .bold()
                                                        .font(.system(size: 18))
                                                }
                                        }

                                    }
                                    .padding(20)
                                    
                                    
                                }
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white)
                                    .shadow(radius: 8, x:5, y:5)
                                )
                                .padding()
                            }
                        }
                    }
                    .frame(height: 600)
                    .padding(.horizontal)
                    .offset(y: 70)
                    
                    //                    VStack {
                    //                        List {
                    //                            ForEach(ISBNs.indices, id: \.self) { index in
                    //                                HStack {
                    //
                    //                                    TextField("ISBN", text: $ISBNs[index])
                    //                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                                        .padding(.vertical)
                    //                                }
                    //
                    //                            }
                    //                        }
                    //                        .frame(height: 600)
                    //                        .offset(y: 70)
                    //                    }
                }
                else if currentStep == 3 {
                    VStack {
                        
                    }
                }
                VStack {
                    ProgressBarView(step: currentStep)
                        .padding(.horizontal, 20)
                        .padding(.top, 50)
                    HStack {
                        ForEach(0..<steps.count, id: \.self) { index in
                            Text(steps[index])
                                .fontWeight(currentStep == index+1 ? .bold : .regular)
                                .font(currentStep == index+1 ? .title : .body)
                                .padding(.horizontal)
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 100)
                
                //                VStack {
                //                    Spacer()
                //                    Button {
                //                        withAnimation {
                //                            currentStep = currentStep + 1
                //                        }
                //                    } label: {
                //                        Text("step + 1")
                //                    }
                //                    Button {
                //                        withAnimation {
                //                            currentStep = currentStep - 1
                //                        }
                //                    } label: {
                //                        Text("step - 1")
                //                    }
                //                }
            }
            
            
            
            
            //                        VStack {
            //                            //            Image(uiImage: UIImage(named: name)!)
            //                            if let image = image {
            //                                Image(uiImage: image)
            //                                    .resizable()
            //                                    .scaledToFit()
            //                            }
            //                            //这个循环是显示获取的文本
            //                            ForEach(textStrings, id: \.self) { testString in
            //                                if isISBN(string: testString) {
            //                                    Text(testString) // 显示ISBN号码
            //                                }
            //                            }
            //
            //
            //                        }
        }
    }
    
    func uploadImg () {
        
    }
    
    
    func bookPrecheck (isbn: String) {
        
        let networkService = NetworkService()
        networkService.bookPrecheckService(isbn: isbn) { result in
            switch result {
            case .success(let response):
                self.receivBook = response.data
                Books.append(receivBook)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func textRecg () {
        textStrings = []
        
        //生成执行需求的CGImage，也就是对这个图片进行OCR文本识别
        //                guard let cgImage = UIImage(named: name)?.cgImage else { return }
        guard let cgImage = image?.cgImage else { return }
        //创建一个新的图像请求处理器
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        //创建一个新的识别文本请求
        let request = VNRecognizeTextRequest(completionHandler: handleDetectedText)
        //使用accurate模式识别，不推荐使用fast模式，因为这是采用传统OCR的，精度太差了
        request.recognitionLevel = .accurate
        //设置偏向语言，不加的话会全按照英文和数字识别
        //中文一起能识别的其他文字只有英文
        //繁体中文为zh-Hant，其他语言码请见https://www.loc.gov/standards/iso639-2/php/English_list.php
        request.recognitionLanguages = ["zh-Hans"]
        
        do {
            //执行文本识别的请求
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        
        if !ISBNs.isEmpty {
            withAnimation {
                currentStep = currentStep + 1
            }
        }
        
    }
    //这个函数用来处理获取的文本
    func handleDetectedText(request: VNRequest?, error: Error?) {
        if let error = error {
            print("ERROR: \(error)")
            return
        }
        //results就是获取的结果
        guard let results = request?.results, results.count > 0 else {
            print("No text found")
            return
        }
        
        //通过循环将results的结果放到textStrings数组中
        //你可以在这里进行一些处理，比如说创建一个数据结构来获取获取文本区域的位置和大小，或者一些其他的功能。！！！通过observation的属性就可以获取这些信息！！！
        for result in results {
            if let observation = result as? VNRecognizedTextObservation {
                //topCandidates(1)表示在候选结果里选择第一个，最多有十个，你也可以在这里进行一些处理
                for text in observation.topCandidates(1) {
                    //将results的结果放到textStrings数组中
                    let string = text.string
                    textStrings.append(string)
                    
                }
            }
        }
        
        for res in textStrings {
            if isISBN(string: res) {
                ISBNs.append(res)
                bookPrecheck(isbn: res)
            }
        }
    }
    
    
    func isISBN(string: String) -> Bool {
        //        let pattern = "^ISBN\\d{1,5}-\\d{3}-\\d{5}-\\d{1}$"
        let pattern = "^ISBN"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex?.firstMatch(in: string, options: [], range: range) != nil
    }
    
}

#Preview {
    StorageView()
}
