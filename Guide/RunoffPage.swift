//
//  RunoffPage.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 12.02.2024.
//

import SwiftUI

struct RunoffPage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
        Text(
            """
            Instant runoff!
            """
        )
        
        ControlPanel()
        Leaderboard()
    }
}

#Preview {
    RunoffPage()
}
