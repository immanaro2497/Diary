//
//  HoldButton.swift
//  Diary
//
//  Created by Immanuel on 14/04/24.
//

import SwiftUI

struct HoldButton: View {
    
    @State private var isDetectingPress = false
    @Binding var showPassword: Bool
    let imageColor: Color
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    
    var body: some View {
        
        Button(action: {
            if isDetectingPress {
                showPassword = false
                isDetectingPress = false
            }
        }, label: {
            Image(systemName: showPassword ? "eye.slash" : "eye")
                .tint(imageColor)
        })
        .frame(width: imageWidth, height: imageHeight)
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2)
                .onEnded { _ in
                    showPassword = true
                    isDetectingPress = true
                }
        )
        .simultaneousGesture(
            DragGesture(minimumDistance: 100)
                .onEnded({ val in
                    showPassword = false
                    isDetectingPress = false
                })
        )
        
    }
    
}
