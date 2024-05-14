//
//  TestView.swift
//  Diary
//
//  Created by Immanuel on 07/04/24.
//

import SwiftUI
import OSLog
import MapKit

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct CirclePositionsKey: PreferenceKey {
    static var defaultValue: [Int: CGPoint] { [:] }
    
    static func reduce(value: inout [Int : CGPoint], nextValue: () -> [Int : CGPoint]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct Line {
    var start: CGPoint = .zero
    var end: CGPoint = .zero
}

struct TestView: View {
    
    let logger = Logger(subsystem: "com.example.diary", category: "LoginView")
    
    //    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    let rows = 10
    let columns = 5
    let spacing: CGFloat = 10

        var body: some View {
            ZStack {
                LazyVGrid(
                    columns: Array(
                        repeating: GridItem(.flexible(), spacing: spacing),
                        count: columns
                    ),
                    spacing: spacing
                ) {
                    ForEach(0..<rows * columns, id: \.self) { index in
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 50, height: 50)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                GeometryReader { proxy in
                                    ZStack {
                                        if (index / columns) > 0 {
                                            Color.orange
                                                .frame(width: 2)
                                                .offset(y: -(proxy.size.height + spacing) / 2)
                                        }
                                        if !index.isMultiple(of: columns) {
                                            Color.red
                                                .frame(height: 2)
                                                .offset(x: -(proxy.size.width + spacing) / 2)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                }
                            }
                    }
                }
                .padding(10)
            }
        }
    }

#Preview {
    VStack {
        TestView()
    }
    .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
    .background(.white)
}

/*
 
@State var borderInit: Bool = false
@State var spinArrow: Bool = false
@State var dismissArrow: Bool = false
@State var displayCheckmark: Bool = false

var body: some View {
    ZStack {
        Color.black.ignoresSafeArea()
        Circle()
            .strokeBorder(style: StrokeStyle(lineWidth: borderInit ? 10 : 64))
            .foregroundColor(borderInit ? .white : .black)
            .animation(.easeOut(duration: 3).speed(1.5), value: borderInit)
            .onAppear() {
                print("10.0123".hasPrefix("10.01234"))
                borderInit.toggle()
            }
        
        Image(systemName: "arrow.2.circlepath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(0.3)
            .foregroundColor(.white)
            .rotationEffect(.degrees(spinArrow ? 360 : -360))
            .opacity(dismissArrow ? 0 : 1)
            .animation(.easeOut(duration: 2), value: dismissArrow)
            .animation(.easeOut(duration: 2), value: spinArrow)
            .onAppear() {
                spinArrow.toggle()
                withAnimation(Animation.easeInOut(duration: 1).delay(1)) {
                    self.dismissArrow.toggle()
                }
            }
        
        CheckmarkShape()
            .trim(from: 0, to: displayCheckmark ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
            .foregroundColor(displayCheckmark ? .white : .black)
            .animation(.bouncy.delay(2), value: displayCheckmark)
            .aspectRatio(contentMode: .fit)
            .onAppear() {
                displayCheckmark.toggle()
            }
    }
    
}

struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + (rect.width * 0.20), y: rect.minY + (rect.height * 0.65)))
        path.addLine(to: CGPoint(x: rect.minX + (rect.width * 0.35), y: rect.minY + (rect.height * 0.8)))
        path.addLine(to: CGPoint(x: rect.minX + (rect.width * 0.8), y: rect.minY + (rect.width * 0.3)))
        return path
    }
}
 */

/*
 
 let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
 @State private var time: Int = 5
 @State private var progress: CGFloat = 0.0
 let num = 5
 
 var body: some View {
     
     VStack(spacing: 36) {
         ZStack {
             Circle()
                 .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                 .frame(width: 300, height: 300)
                 .foregroundStyle(.gray.opacity(0.5))
             Circle()
                 .trim(from: 0.0, to: progress)
                 .rotation(.degrees(-90))
                 .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                 .transition(.asymmetric(insertion: .slide, removal: .identity))
                 .frame(width: 300, height: 300)
                 .foregroundStyle(.cyan)
             Text(time, format: .number)
                 .onReceive(timer, perform: { value in
                     if time > 0 {
                         withAnimation(.linear(duration: 1)) {
                             time -= 1
                             progress = CGFloat(CGFloat(num - time) / CGFloat(num))
                         }
                     } else {
                         time = num
                         progress = 0.0
                     }
                 })
                 .foregroundStyle(.white)
         }
         Button(action: {
             time = num
             progress = 0.0
         }, label: {
             Text("reset")
         })
     }
     
 }
 
 */


