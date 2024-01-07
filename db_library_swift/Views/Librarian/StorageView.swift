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
    
//    @State var ISBNs: [String] = ["ISBN7-305-02368-9", "ISBN7-306-02368-9", "ISBN7-309-02368-9"]
    @State var ISBNs: [String] = []
//    @State var increaseNum: [Int] = [1, 2, 3]
    var body: some View {
        
        VStack {
            ZStack {
                if currentStep == 1 {
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
                    VStack {
                        List {
                            ForEach(ISBNs.indices, id: \.self) { index in
                                HStack {
                                    
                                    TextField("ISBN", text: $ISBNs[index])
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.vertical)
                                    
                                    
                                }
                            }
                        }
                        .frame(height: 600)
                        .offset(y: 70)
                    }
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
        
        withAnimation {
            currentStep = currentStep + 1
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
