//
//  LaunchScreenView.swift
//  Diary
//
//  Created by Immanuel on 07/04/24.
//

import SwiftUI

extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)
            .speed(1)
            .delay(0.1 * Double(index))
    }
}

struct LaunchScreenView: View {
    @Binding var visibleScreen: VisibleScreen
    @State private var startAnimation = false
    @State private var rotation: CGFloat = 0.0
    
    func singleTextView(text: String, index: Int) -> some View {
        Text(text)
            .font(Fonts.scaledFont40)
            .scaleEffect(startAnimation ? 1.5 : 0.5)
            .offset(x: startAnimation ? CGFloat((30 * index) - 60) : 0, y: startAnimation ? -200 : -50)
            .animation(.ripple(index: index), value: startAnimation)
            .foregroundStyle(.white)
    }
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(Array("DIARY".enumerated()), id: \.offset) { index, value in
                    singleTextView(text: value.description, index: index)
                }
            }
            Image("BirdImage")
                .scaleEffect(startAnimation ? 0.5 : 1)
                .animation(.spring(dampingFraction: 0.6).speed(0.8), value: startAnimation)
                .overlay {
                    
                }
        }
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(.launchBackground)
        .onAppear {
            withAnimation {
                startAnimation = true
            } completion: {
                visibleScreen = .loginScreen
            }
        }
    }
}

#Preview {
    LaunchScreenView(visibleScreen: .constant(.launchScreen))
}

