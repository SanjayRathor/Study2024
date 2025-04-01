//
//  ListView.swift
//  SwitUIApp
//
//  Created by Sanjay Singh Rathor on 24/10/20.
//  Copyright © 2020 Timesinternet ltd. All rights reserved.
//

import SwiftUI
//\.self, which means: “Use the item’s value as its identifier.”
struct ListView: View {
    
    @State var checklistItems = [
        "Take vocal lessons",
        "Record hit single",
        "Learn every martial art",
        "Design costume",
        "Design crime-fighting vehicle",
        "Come up with superhero name",
        "Befriend space raccoon",
        "Save the world",
        "Star in blockbuster movie",
    ]
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(checklistItems, id: \.self) { item in
                    Text(item)
                        .onTapGesture {
                            //self.checklistItems.append(item)
                            self.checklistItems.remove(at: 0)
                            self.printChecklistContents()
                        }
                }
                
            }
            .navigationBarItems(trailing: EditButton())
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Checklist")
            .onAppear() {
                self.printChecklistContents()
            }
        }.onAppear {
            print("asdasdad")
        }
    }
    
    func printChecklistContents() {
        for item in checklistItems {
            print(item)
        }
    }
    
}

/*
 struct ListView: View {
 
 var body: some View {
 NavigationView {
 List {
 Section(header: Text("High priority")) {
 Group {
 Text("Walk the dog")
 Text("Brush my teeth")
 }
 Group {
 Text("Finish homework")
 Text("Change internet provider")
 Text("Read RayWenderlich.com")
 Text("Clean the kitchen")
 Text("Wash the car")
 }
 
 
 }
 Section(header: Text("Low priority")) {
 Text("Soccer practice")
 Text("Eat ice cream")
 }
 
 
 }
 .listStyle(GroupedListStyle())
 .navigationBarTitle("Checklist") }
 }
 }
 */

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
