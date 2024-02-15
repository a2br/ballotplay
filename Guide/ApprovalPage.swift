//
//  ApprovalPage.swift
//
//
//  Created by Anatole Debierre on 13.02.2024.
//

import SwiftUI


struct ApprovalPage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
            Text("Approval Page")
        
            ControlPanel()
        
            Leaderboard()
            .block()
    }
        
}
