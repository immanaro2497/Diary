//
//  CustomViewModifiers.swift
//  Diary
//
//  Created by Immanuel on 12/04/24.
//

import SwiftUI

struct SizeCalculator: ViewModifier {
    
    let name: String
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { reader in
                    let _ = print("\(name) - \(reader.size)")
                    Color.clear
                }
            )
    }
    
}

struct TestAnimateViewAppear: ViewModifier {
    
    @State private var isVisible = false
    let width: CGFloat = 5
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                Rectangle()
                    .stroke(lineWidth: width)
                    .phaseAnimator([Color.clear, Color.black, Color.white, Color.black], trigger: isVisible) { view, phase in
                        view.foregroundStyle(phase)
                    } animation: { _ in
                            .easeInOut.speed(2)
                    }
            })
            .onAppear {
                isVisible.toggle()
            }
    }
    
}
