//
//  SwiftUIViewStudy.swift
//  StudySwiftUI
//
//  Created by Sanjay Rathor on 28/03/25.
//

import SwiftUI

struct SwiftUIViewStudy: View {
    var body: some View {
        
        VStack(spacing: 20) {
            DisclosureGroup("More Info") {
                Text("Tap the row to expand/collapse the content of the DisclosureGroup. DisclosureGroups are collapsed by default.")
            }
            DisclosureGroup(
                content: {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(.orange)
                    Text("You can use another initializer to customize your label too.")
                },
                label: {
                    Text("More Info")
                        .bold()
                })
        }
        .padding(.horizontal)
        
        Label {
            Text("Camera Settings")
                .foregroundStyle(.purple)
            
        } icon: {
            Image(systemName: "camera.badge.ellipsis")
                .foregroundStyle(.pink)
        }
        
        
        /*VStack(spacing: 20.0) {
         ControlGroup {
         Button("Hello!") { }
         Button(action: {}) {
         Image(systemName: "gearshape.fill")
         }
         }
         
         ControlGroup {
         Button("Hello!") { }
         Button(action: {}) {
         Image(systemName: "gearshape.fill")
         }
         }
         .controlGroupStyle(.navigation)
         }
         .font(.title)
         */
        //        Button("Capsule") { }
        //        .buttonBorderShape(.capsule)
        //        .buttonStyle(.borderedProminent)
        //
        //        Button(action: {}) {
        //            Text("Solid Buttonjsb djjbadsj asdb sajdb asd")
        //                .padding()
        //                ///.foregroundStyle(.white)
        //                //.background(Capsule(style: .circular))
        //                .background(Color.red)
        //                .buttonBorderShape(.capsule)
        //                .buttonStyle(.borderedProminent)
        //
        //                //.background(Color.purple, in: Capsule())
        //                //.shadow(color: Color.purple, radius: 1, y: 5)
        //               // .clipShape(RoundedRectangle(cornerRadius: 16))
        //        }
        
        
    }
}


struct SwiftUIViewStudyd: View {
    var body: some View {
        
        TabView {
            
            Text("Call Screen")
                .tabItem {
                    Image(systemName: "phone")
                    Text("Call")
                }
            Text("Outgoing Phone Calls Screen")
                .tabItem {
                    Image(systemName: "phone.arrow.up.right")
                    Text("Outgoing")
                }
            Text("Incoming Phone Calls Screen")
                .tabItem {
                    Image(systemName: "phone.arrow.down.left")
                    Text("Incoming")
                }
            Text("Phone Book Screen")
                .tabItem {
                    Image(systemName: "book")
                    Text("Phone Book")
                }
            Text("History Screen")
                .tabItem {
                    Image(systemName: "clock")
                    Text("History")
                }
            
            Text("New Phone Number")
                .tabItem {
                    Image(systemName: "phone.badge.plus")
                    Text("New")
                }
        }
        //.tabViewStyle(.tabBarOnly)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct TabView_Customizations: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("People")
            TabView {
                ForEach(1 ..< 21) { index in
                    VStack(spacing: 20) {
                        Text("Person \(index)")
                        Image("profile\(index)")
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(16)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color.yellow.opacity(0.7)))
                    .padding()
                }
            }
        }
        .font(.title)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct TabView_POPUP: View {
    @State private var showingModal = true
    var body: some View {
        ZStack {
            
            // The Custom Popup is on top of the screen
            if $showingModal.wrappedValue {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    // This VStack is the popup
                    VStack(spacing: 20) {
                        Text("Popup")
                            .bold().padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .foregroundStyle(Color.white)
                        Spacer()
                        Button(action: {
                            self.showingModal = false
                        }) {
                            Text("Close")
                        }.padding()
                    }
                    .frame(width: 300, height: 200)
                    .background(Color.white)
                    .cornerRadius(20).shadow(radius: 20)
                }
            }
        }
    }
}


struct Sheet_Detents: View {
    @State private var showSheet = false
    var body: some View {
        Button("Show Half Sheet") {
            showSheet.toggle()
        }
        
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16.0) {
                Text("Using a medium and large detent to present this sheet.")
                Image(systemName: "arrow.up")
                Text("Slide up to go from medium to large detent.")
            }
            .padding()
            .presentationDetents([.medium, .large])
            .presentationBackground(.thinMaterial)
            .presentationCornerRadius(80)
        }
        
        .font(.title)
    }
}


struct Toolbar_ControlGroup: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
            }
            .navigationTitle("Toolbar")
            .font(.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ControlGroup {
                        Button(action: {}) {
                            Image(systemName: "aspectratio")
                        }
                        Button(action: {}) {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    .controlGroupStyle(.navigation)
                }
            }
            .tint(.green)
        }
    }
}




#Preview {
    Toolbar_ControlGroup()
}

