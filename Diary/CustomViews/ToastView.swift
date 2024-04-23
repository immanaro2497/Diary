//
//  ToastView.swift
//  Diary
//
//  Created by Immanuel on 18/04/24.
//

import SwiftUI

struct ToastView: View {
    
    @State private var showingImage = false
    @State private var showingMessage = false
    @Binding var message: String
    
    var body: some View {
        
        HStack  {
            
            if showingImage {
                Image(systemName: "info.circle.fill")
                    .font(.title)
                    .foregroundStyle(.linearGradient(colors: [.blue, .launchBackground], startPoint: .top, endPoint: .bottom))
                    .padding(8)
                    .background(.white.gradient.opacity(0.5), in: .circle)
            }
            
            if showingMessage {
                Text(message)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.trailing, 20)
            }
            
        }
        .clipShape(.capsule)
        .background(.launchBackground.opacity(1))
        .background(.white.shadow(.drop(color: .white.opacity(0.5), radius: 5, y: 10)), in: .capsule)
        .overlay(
            Capsule()
                .stroke(lineWidth: 5)
                .foregroundStyle(.white)
        )
        .task {
            Task {
                withAnimation(.spring(duration: 0.3, bounce: 0.5)) {
                    showingImage = true
                }
                try await Task.sleep(for: .seconds(0.5))
                withAnimation {
                    showingMessage = true
                }
                try await Task.sleep(for: .seconds(2))
                withAnimation {
                    showingMessage = false
                }
                try await Task.sleep(for: .seconds(0.5))
                withAnimation {
                    showingImage = false
                }
                message = ""
            }
        }
        
    }
}

#Preview {
    VStack {
        ToastView(message: .constant("Toast message"))
    }
    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
    .background(.launchBackground)
}
