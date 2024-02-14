//
//  SpoilerPage.swift
//
//
//  Created by Anatole Debierre on 11.02.2024.
//

import SwiftUI


struct SpoilerPage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
        VStack {
            Text("Spoiler Page \(election.candidates.count)")
        }
    }
        
}
