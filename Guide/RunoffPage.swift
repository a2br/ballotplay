//
//  RunoffPage.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 12.02.2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct RunoffPage: View {
    @Binding var page: Page

    @EnvironmentObject var election: Election
    
    var body: some View {
        VStack {
            ControlPanel()
            Leaderboard()
        }
        
        Text(
            "We just saw that with Plurality Voting, it’s sometimes in your best interest to lie… So, what if you had fallbacks to your ballot? If your favorite candidate doesn’t stand a chance, then your ballot picks your 2nd favorite!"
        )
        
        Text(
            "That’s the entire premise of Instant Runoff Voting (IRV). A simpler way to visualize it would be by using multiple election rounds, eliminating the weakest candidate each time & stopping whenever someone gains over 50% of the votes."
        )
        
        Text("Of course, there's a catch.")
            .bold()
        
        NextButton(page: $page, text: "How so?")

    }
}
