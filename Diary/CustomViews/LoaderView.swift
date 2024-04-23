//
//  LoaderView.swift
//  Diary
//
//  Created by Immanuel on 12/04/24.
//

import SwiftUI

extension Animation {
    static func open(index: Int) -> Animation {
        Animation.linear(duration: 0.5).delay(0.3 * Double(index))
    }
}

struct LoaderView: View {
    
    @State private var degrees: Double = -0
    
    var body: some View {
        ZStack {
            ForEach(Array("DIARY".enumerated()).reversed(), id: \.offset) { index, value in
                RoundedRectangle(cornerRadius: 115)
                    .frame(width: 512, height: 512)
                    .foregroundStyle(.white)
                    .overlay {
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .frame(width: 380, height: 380)
                                .foregroundStyle(.launchBackground)
                            Text(value.description)
                                .font(.custom("Georgia", size: 17, relativeTo: .title))
                                .font(.system(size: 20, weight: .heavy, design: .rounded))
                                .foregroundStyle(.white)
                                .scaleEffect(5)
                        }
                    }
                    .rotation3DEffect(
                        .degrees(degrees),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        anchorZ: -0,
                        perspective: 0.1
                    )
                    .animation(.open(index: index + 1), value: degrees)
            }
            Image(.bird)
                .background(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 115)
                )
                .rotation3DEffect(
                    .degrees(degrees),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: .leading,
                    anchorZ: -0,
                    perspective: 0.1
                )
                .animation(.open(index: 0), value: degrees)
        }
        .onAppear(perform: {
            degrees = -90
        })
        .scaleEffect(0.5)
    }
}

#Preview {
    LoaderView()
}

/*
 Rotation
 RoundedRectangle(cornerRadius: cornerRadius)
     .frame(width: 100, height: height + 150)
     .rotationEffect(.degrees(rotation))
     .foregroundStyle(.white)
     .mask {
         RoundedRectangle(cornerRadius: cornerRadius)
             .stroke(lineWidth: lineWidth)
             .frame(width: width, height: height)
     }
     .onAppear {
         withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
             rotation = 360
         }
     }
 */
