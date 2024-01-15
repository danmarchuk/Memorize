//
//  MainMenu.swift
//  Memorize
//
//  Created by Данік on 31/12/2023.
//

import SwiftUI

struct MainMenu: View {
    
    @State private var items: [GameInfo] = [GameInfo(id: 1, title: "Elf", emojis: "🧝‍♀️🩲👗👠👑🐰🐸🐝", color: Color.green), GameInfo(id: 2, title: "Mice", emojis: "🐭🐹🐌❤️‍🔥😌😍😎😏", color: Color.gray), GameInfo(id: 3, title: "First", emojis: "🤖👽🎃🥶🛐🦷🍑🤓", color: Color.black)]
    @State private var isEditing = false
    @State private var selectedItem: Int?
    
    var body: some View {
        NavigationView {
            VStack {
                plusButton
                memorizeLabel
                gamesList            }
            .navigationBarHidden(true) // Hiding the navigation bar
            .sheet(isPresented: $isEditing) {
                if let selectedItemIndex = items.firstIndex(where: {$0.id == selectedItem}) {
                    EditScreen(item: $items[selectedItemIndex].emojis, title: $items[selectedItemIndex].title, selectedColor: $items[selectedItemIndex].color)
                }
            }
        }
    }
    
    var plusButton: some View {
        // Plus Button in the Top Right Corner
        Button(action: {
            // Action for the plus button
            withAnimation(.default) {
                // later create three fucntions: random name, random emojis and random color
                items.append(GameInfo(id: randomNumber(), title: "Amongus", emojis: "😈☠️🤡", color: Color.blue))
            }
        }) {
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(.blue)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var memorizeLabel: some View {
        // Label
        Text("Memory Game")
            .font(.title)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var gamesList: some View {
        List(items, id: \.self) { item in
            // if the user clicked on the chosen cell a new game opens
            NavigationLink(destination: EmojiMemoryGameView(game: EmojiMemoryGame (emojis: item.emojis.map{String($0)}), title: item.title, cardColor: item.color) ) {
                CustomCellView(title: item.title, subtitle: item.emojis, themeColor: item.color)
            }
            // User swiped right and the Edit screen is shown
            .swipeActions(edge: .leading) {
                Button("Edit") {
                    // Set the selected item index and present the sheet
                    selectedItem = item.id
                    isEditing = true
                }
                .tint(.blue)
            }
            // User swiped left and the Delete button is shown
            .swipeActions(edge: .trailing ) {
                Button("Delete") {
                    withAnimation(.spring()) {
                        if let index = items.firstIndex(of: item) {
                            items.remove(at: index)
                        }
                    }
                }
                .tint(.red)
            }
        }
        .listStyle(PlainListStyle())
        .background(Color.white)
    }
    
    private func randomNumber() -> Int {
        return Int.random(in: 1...1000000)
    }
}

struct GameInfo: Hashable, Identifiable {
    var id: Int
    var title: String
    var emojis: String
    var color: Color
}

#Preview {
    MainMenu()
}
