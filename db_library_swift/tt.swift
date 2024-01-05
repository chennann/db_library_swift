//
//  tt.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/5.
//

import SwiftUI
import Vision

struct tt: View {
    //这个字符串数组是为了存放获取的文本
    @State var textStrings = [String]()
    //这个name用来指定使用哪个图像，如果想用其他图像修改这个变量就行
    @State var name = "info"
    
    
    @State private var showCamera = false
    @State var image: UIImage?
    
    
    var body: some View {
        
        VStack {
            VStack {
                Button("打开相机") {
                    self.showCamera = true
                }
            }
            .fullScreenCover(isPresented: $showCamera, onDismiss: textRecg) {
                CameraView(image: self.$image)
                    .onDisappear(perform: {
                        textRecg()
                    })
            }
            
            //        VStack {
            //
            //            Button("打开相机") {
            //                self.showCamera = true
            //            }
            //        }
            //        .sheet(isPresented: $showCamera) {
            //            CameraView(image: self.$image)
            //                .onDisappear(perform: {
            //                    textRecg()
            //                })
            //        }
            
            
            VStack {
                //            Image(uiImage: UIImage(named: name)!)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                //这个循环是显示获取的文本
                ForEach(textStrings, id: \.self) { testString in
                    if isISBN(string: testString) {
                        Text(testString) // 显示ISBN号码
                    }
                }
                
                
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
    tt()
}
