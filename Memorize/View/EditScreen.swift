//
//  EditScreen.swift
//  Memorize
//
//  Created by Данік on 31/12/2023.
//

import SwiftUI

struct EditScreen: View {
    @Binding var item: String
    @Binding var title: String
    @Binding var selectedColor: Color
    @State private var inputText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Text("Edit Emoji")
                    .font(.title)
                    .foregroundColor(selectedColor)
                    .fontWeight(.bold)
                Spacer()
                Button("Done") {
                    // Save the edited content and dismiss the sheet
                    item += inputText
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding()

            VStack {
                HStack {
                    Text("Title:")
                    TextField("Edit title", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                HStack {
                    Text("Edit set:")
                    TextField("Enter emojis", text: $item)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    ColorPicker("", selection: $selectedColor)
                        .frame(width: 50, height: 50)
                }
                .padding()
            }
        }
        .padding()
    }
}
