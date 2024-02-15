//
//  CenterSqueeze.swift
//
//
//  Created by Anatole Debierre on 11.02.2024.
//

import SwiftUI

let LEGIT_INDEX = 0
let CENTRIST_INDEX = 1
let LOSER_INDEX = 2

@available(iOS 17.0, *)
struct CenterSqueezePage: View {
    @EnvironmentObject var election: Election
    
    var body: some View {
        
        // Filters out the intermediate period where the old election is available
        let valid = election.candidates.count == 3
        if valid {
            
            let legit = election.candidates[LEGIT_INDEX]
            let centrist = election.candidates[CENTRIST_INDEX]
            let loser = election.candidates[LOSER_INDEX]
            
            let rounds = election.irvRounds()
            let done = rounds.last!.pluralityTally().first!.key == centrist
            
            // ResetButton(target: .centerSqueeze)
            Leaderboard()
            
            Group {
                Text("Take this scenario. Imagine ") + loser.quote() + Text("'s supporters would absolutely hate seeing ") + legit.quote() + Text(" elected.")
            }
                .block()
            
            Group {
                Text("It's easy to see how ") + loser.quote() + Text("'s voters might be tempted to vote for the centrist ") + centrist.quote() + Text(" in the 1st round, resulting in a better outcome for them.")
            }
            .block()
            
            Group {
                Text("One way to model this behavior would be to toss ") + loser.quote() + Text(" to the outskirts of the Compass, forfeiting their votes to ") + centrist.quote() + Text(".")
            }
            .block()
            
            Callout(color: loser.color, used: done) {
                Text("Move ") + loser.quote() + Text(" to the upper right corner, so that fewer of their supporters vote for them.")
            }
            
            if done {
                Group {
                    Text("The outcome is now better for ") + loser.quote() + Text("'s supporters! For them, it's the lesser of two evils, ") + legit.quote() + Text(" or ") + centrist.quote() + Text(". Sadly, you've just proved that voting strategies still persist under IRV. This is called the Center Squeeze.")
                }
            }
        }
    }
        
}
