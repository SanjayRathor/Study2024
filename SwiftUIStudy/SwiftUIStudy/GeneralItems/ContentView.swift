//
//  ContentView.swift
//  SwiftUIStudy
//
//  Created by Sanjay Rathor on 08/02/25.
//

import SwiftUI

struct ContentView: View {
    let source = RemoteFile(url: URL(string: "https://hws.dev/inbox.json")!, type: [Message].self)
    @State private var messages = [Message]()
    
    var body: some View {
        NavigationStack {
            List(messages) { message in
                VStack(alignment: .leading) {
                    Text(message.user)
                        .font(.headline)
                    Text(message.text)
                    
                }
            }
            .navigationTitle("Inbox")
            .toolbar {
                Button("Refresh", systemImage: "arrow.clockwise",
                       action: refresh)
            }
            .onAppear(perform: refresh)
        }
    }
    
    func refresh() {
        Task {
            do {
                // Access the property asynchronously
                messages = try await source.contents
               // await loadData()
            } catch {
                print("Message update failed.")
            }
        }
    }
}

#Preview {
    ContentView()
}
