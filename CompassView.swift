//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

struct CompassView: View {
    @ObservedObject var election: Election

    var body: some View {
        VStack {
            Spacer()
            
            VStack(alignment: .leading) {
                if election.votingSystem == VotingSystem.plurality {
                    
                    let winner = election.pluralityTally().first?.key
                    let _ = election.setWinningColor(winner?.color ?? .gray)
                    Group {
                        //Find who the fuck is winning
                        Text(winner?.name ?? "Nobody")
                            .foregroundColor(winner?.color ?? .gray)
                        + Text(" is winning with Plurality Voting.")
                    }
                    .font(.system(size: 35, weight: .bold))
                    GeometryReader { geo in
                            Compass(election: election)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .shadow(color: election.winningColor.opacity(0.9), radius: 300)
                                .zIndex(1)
                    }
                    .aspectRatio(contentMode: .fit)
                }
            }
            .padding(25)
        }
    }
}

