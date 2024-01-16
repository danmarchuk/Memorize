//
//  CustomCellView.swift
//  Memorize
//
//  Created by Данік on 31/12/2023.
//

import SwiftUI

struct MenuCell: View {
    var title: String
    var subtitle: String
    var themeColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeColor)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
