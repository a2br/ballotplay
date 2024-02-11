//
//  SpoilerPage.swift
//
//
//  Created by Anatole Debierre on 11.02.2024.
//

import SwiftUI

var saved: Election?

struct SpoilerPage: View {
    @EnvironmentObject var election: Election
    var special: Election = Election(voters: Voter.populate(density: 0.2))
    
    var body: some View {
        VStack {
            Text("Spoiler Page \(election.candidates.count)")
        }
    }
        
}
