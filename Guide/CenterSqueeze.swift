//
//  CenterSqueeze.swift
//
//
//  Created by Anatole Debierre on 11.02.2024.
//

import SwiftUI

let CENTER_INDEX = 1

struct CenterSqueezePage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
        
        let done = election.irvRounds().last!.pluralityTally().first!.key == election.candidates[CENTER_INDEX]
        
        Text("Spoiler Page \(election.candidates.count)")
        
        Button {
            election.push(specialElections[.centerSqueeze]!)
        } label: {
            Label("Reset", systemImage: "arrow.counterclockwise")
        }
        
        if done {
            Text("Well done! It's done. You've proved it, yay. You've proved it, yay. You've proved it, yay. You've proved it, yay.")
        }
    }
        
}
