//
//  ContentView.swift
//  Memorize
//
//  Created by Данік on 22/02/2023.
//

import SwiftUI

struct ContentView: View {
    var emojis = ["😈", "🤡", "👻", "😸", "✊🏿", "👧", "🫦", "🧔‍♂️", "🦸", "👩‍🎤", "🧝‍♀️", "🩲", "👗", "👠", "👑", "🐰", "🐸" ]
    @State var emojiCount = 6
    var body: some View {
        HStack {
            CardView()
            CardView()
            CardView()
            CardView()
        }
        .padding(.horizontal)
        .foregroundColor(.red)
    }
    
    var remove: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            VStack{
                Image(systemName: "minus.circle")
            }
        }
    }
    
    var add: some View {
        
        Button {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        } label: {
            VStack{
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp: Bool = true
    
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.stroke(lineWidth: 3)
                Text(content)
                    .font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
        ContentView()
            .preferredColorScheme(.light)
    }
}
