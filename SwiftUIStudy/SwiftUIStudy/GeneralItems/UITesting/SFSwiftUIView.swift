//
//  SFSwiftUIView.swift
//  StudySwiftUI
//
//  Created by Sanjay Rathor on 12/03/25.
//

import SwiftUI

//struct SFSwiftUIView: View {
//    @State private var usesFixedSize = false
//    var body: some View {
//        TupleView((
//        Text("1"),
//        Text("2"),
//        Text("3"),
//        Text("4"),
//        TupleView((
//        Text("a"),
//        Text("s"),
//        Text("d"),
//        Text("f")
//        )),
//        Text("5"),
//        Text("6"),
//        Text("7"),
//        Text("8"),
//        Text("9"),
//        Text("10"),
//        Text("11"),
//        Text("12"),
//        Text("13"),
//        Text("14"),
//        Text("15")
//        ))
//    }
//}

//struct SFSwiftUIView: View {
//    @State private var usesFixedSize = false
//    var body: some View {
//        VStack {
//            if Bool.random() {
//                Text("Hello")
//            } else {
//                Text("Goodbye")
//            }
//        }
//        .onTapGesture {
//            print(type(of: self.body))
//        }
//    }
//}

//struct SFSwiftUIView: View {
//    @State private var items = Array(1...20)
//    var body: some View {
//        VStack(spacing: 0) {
//            List(items, id: \.self) {
//                Text("Item \($0)")
//            }
//            .id(UUID())
//            .transition(.asymmetric(insertion: .move(edge: .trailing),
//            removal: .move(edge: .leading)))
//
//            Button("Shuffle") {
//                withAnimation(.easeInOut(duration: 1)) {
//                   items.shuffle()
//                }
//            }
//            .buttonStyle(.borderedProminent)
//            .padding(5)
//        }
//    }
//}

struct SFSwiftUIView: View {
    @State private var counter = 0

    var body: some View {
       // SFSwiftUIView._printChanges()
        VStack {
            Text("Counter: \(counter)")
                //.id(counter) // Forces recreation of the view when counter changes // if id is missing it will update only Text View

            Button("Increment") {
                counter += 1
            }
        }
    }
}

//struct SFSwiftUIView: View {
//    @State private var scale = 1.0
//    var body: some View {
//        Text("Hello, World!")
//            .scaleEffect(scale)
//          
//            .onTapGesture {
//                scale += 1
////                withAnimation {
////                    scale += 1
////                }
//            } .animation(.default, value: scale)
//    }
//}



#Preview {
    SFSwiftUIView()
}
