//
//  NextButton.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 16.02.2024.
//

import SwiftUI

struct NextButton: View {
    @Binding var page: Page
    var text: String = "Next"

    
    // Must not be used on last page
    var body: some View {
        HStack {
            Spacer()
            Button {
                page = Page(rawValue: page.rawValue + 1)!
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.accentColor)
                    
                    HStack {
                        Text(text)
                            .bold()
                            .foregroundStyle(.white)
                        Image(systemName: "chevron.forward")
                            .bold()
                            .foregroundColor(.white)
                    }
                    .padding(20)
                }
            }
            .frame(maxWidth: 250)

        }
        .padding(.top, 20)
    }
}

