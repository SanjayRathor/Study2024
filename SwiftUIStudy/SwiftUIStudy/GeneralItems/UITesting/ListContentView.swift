//
//  ContentView.swift
//  StudySwiftUI
//
//  Created by Sanjay Rathor on 11/03/25.
//

import SwiftUI

struct ListContentView: View {
    @State private var searchText = ""
    var restaurantNames = [
        "Cafe Deadend",
        "Homei",
        "Teakha",
        "Cafe Loisl",
        "Petite Oyster",
        "For Kee Restaurant",
        "Po's Atelier",
        "Bourke Street Bakery",
        "Haigh's Chocolate",
        "Palomino Espresso",
        "Upstate",
        "Traif",
        "Graham Avenue Meats",
        "Waffle & Wolf",
        "Five Leaves",
        "Cafe Lore",
        "Confessional",
        "Barrafina",
        "Donostia",
        "Royal Oak",
        "CASK Pub and Kitchen"
    ]
    
    var restaurantImages = [
        "cafedeadend",
        "homei",
        "teakha",
        "cafeloisl",
        "petiteoyster",
        "forkee",
        "posatelier",
        "bourkestreetbakery",
        "haighs",
        "palomino",
        "upstate",
        "traif",
        "graham",
        "waffleandwolf",
        "fiveleaves",
        "cafelore",
        "confessional",
        "barrafina",
        "donostia",
        "royaloak",
        "cask"
    ]
    
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(restaurantNames.indices, id: \.self) { index in
                    HStack {
                        Image(restaurantImages[index])
                            .resizable()
                            .frame(width: 120, height: 118)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(5)
                        VStack(alignment: .leading) {
                            Text(restaurantNames[index])
                                .font(.system(.title2, design: .rounded))
                            Text("Type")
                                .font(.system(.body, design: .rounded))
                            Text("Location")
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(.gray)
                        }
                    }
                    
                }
                
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
        }
        //.searchable(text: $searchText, prompt: "Search restaurants...")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode
        : .always), prompt: "Search restaurants...")
        .searchSuggestions{
        Text("Cafe")
        Text("Thai")
        }
        
    }
}

#Preview {
    ListContentView()
    
}
//.preferredColorScheme(.dark)
/*
 onChange(of: searchText) { oldValue, newValue in
 if !newValue.isEmpty {
 searchResult = restaurants.filter { $0.name.contains(newValue) }
 }
 }
 */
