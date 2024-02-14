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
    
    var body: some View {
        
            Text(
                """
                Plurality voting is the most widely used voting system. It is hard to think of something more intuitive: “Just pick the candidate you like best.”
                """
            )
            
            ControlPanel()
            

            
            Text(election.pluralityTally().map { "\($0.key.name): \($0.value)" }.description)

    }
    
}
