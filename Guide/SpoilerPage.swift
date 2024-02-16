//
//  SpoilerPage.swift
//
//
//  Created by Anatole Debierre on 11.02.2024.
//

import SwiftUI

let ENEMY_INDEX = 0
let LEGITIMATE_INDEX = 1
let CHALLENGER_INDEX = 2

@available(iOS 17.0, *)
struct SpoilerPage: View {
    @Binding var page: Page

    @EnvironmentObject var election: Election
    
    var body: some View {
        
        // Filters out the intermediate period where the old election is available
        let valid = election.candidates.count == 3
        
        if valid {
            
            let enemy = election.candidates[ENEMY_INDEX]
            let legit = election.candidates[LEGITIMATE_INDEX]
            let challenger = election.candidates[CHALLENGER_INDEX]
            
            
            let done = election.pluralityTally().first!.key == enemy
            
            // ResetButton(target: .spoilerEffect)
            Leaderboard()
            
            Group {
                Text("Here, we have 3 candidates. Slowly drag ") + challenger.quote() + Text(" closer to ") + legit.quote() + Text(", and watch what happens...")
            }
            
            Callout(color: challenger.color, used: done) {
                Text("Move ") + challenger.quote() + Text(" closer to ") + legit.quote() + Text(".")
            }
            
            if done {
                Group {
                    Text("Now, ") + legit.quote() + Text(" is losing to ") + enemy.quote() + Text("! Even though they'd beat ") + enemy.quote() + Text(" one-on-one, ") + challenger.quote() + Text(" \"stole\" some of her votes simply by having similar opinions.")
                }
                
                Text("This is called the Spoiler Effect, the most criticized flaw of Plurality Voting.")
                
                Text("As voters are encouraged to lie by voting for a more popular candidate (who might have more chances to win), a long-term consequence is the polarization of the political landscape. A great example would be the USA, which is governed by a two-party system.")
                
                NextButton(page: $page)
            }
        }
    }
        
}
