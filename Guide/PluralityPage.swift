//
//  PluralityPage.swift
//
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct PluralityPage: View {
    @EnvironmentObject var election: Election
    @State private var showSheet: Bool = false
    
    var body: some View {
        
            Rectangle()
                .frame(width: 0, height: 0)
                .sheet(isPresented: $showSheet) {
                    Text("hi")
                    Button {
                        showSheet = false
                    } label: {
                        Text("Close :)")
                    }
                }
        
            Text(
                """
                Plurality voting is the most widely used voting system. It is hard to think of something more intuitive: “Just pick the candidate you like best.”
                """
            )
            .block()
        
            Text(
                """
                Feel free to play around with this election. When you’re ready, let’s take a look at why it isn’t enough…
                """
            )
            .block()

            ControlPanel()
            
            Leaderboard()
            .block()

    }
    
}
