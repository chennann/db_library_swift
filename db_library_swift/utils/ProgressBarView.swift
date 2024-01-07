//
//  ProgressView.swift
//  db_library_swift
//
//  Created by chennann on 2024/1/6.
//

import SwiftUI

struct ProgressBarView: View {
    
    var step: Int = 0
    var colorSet: [Color] = [Color.yellow, Color.green, Color.orange, Color.red, Color.blue]
    private let maxProgress = 3

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)

                Rectangle()
                    .foregroundColor(colorSet[step])
                    .frame(width: (geometry.size.width / CGFloat(maxProgress)) * CGFloat(step))
            }
        }
        .frame(height: 10)
        .cornerRadius(10)
        
//        Button {
//            withAnimation {
//                step = step + 1
//            }
//        } label: {
//            Text("+1")
//        }
//
//        Button {
//            withAnimation {
//                step = step - 1
//            }
//        } label: {
//            Text("-1")
//        }
    }
    
}

#Preview {
    ProgressBarView(step: 2)
}
