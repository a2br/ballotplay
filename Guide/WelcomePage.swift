//
//  WelcomePage.swift
//
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        
        VStack(alignment: .leading) {
            Group {
                Text("Let's start by playing around with the ") +
                Text("Political Compass")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/) +
                Text(" on your left! It's a lot of fun. Try moving some squares around, and guess what they might represent! This is some more text to see how the layout is going to react.")
            }
            .fixedSize(horizontal: false, vertical: true) // Allow for multiple lines (even when they're not filled)
            
            
        }
        .navigationTitle("Voting Systems 101")
    }
}
