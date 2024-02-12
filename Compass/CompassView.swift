//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct CompassView: View {
    @EnvironmentObject var election: Election
    @State var round = 0
    var irvRounds: [Election] {
        election.irvRounds()
    }
    var facade: Election {
        let irvRounds = irvRounds
        return irvRounds[round]
    }
    
    // For IRV, updates the root election
    func onCandidateMove(_ candidate: Candidate) -> Void {
        election.candidates = election.candidates.map { c in
            if c.id == candidate.id {
                return Candidate(id: c.id,opinion: candidate.opinion, name: c.name, color: c.color)
            } else {
                return c
            }
        }
        
        round = min(round, irvRounds.count - 1)
    }
    
    var body: some View {
        VStack
            {
                Spacer()
                
                VStack(alignment: .leading) {
                    switch election.votingSystem {
                    case .plurality:
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
                        }
                        .aspectRatio(contentMode: .fit)
                    case .runoff:
                        // Brand new election
                        HStack {
                            Button {
                                round = max(round - 1, 0)
                            } label: {
                                Text("Rem -")
                            }
                            
                            Text("Round: \(round)")
                            
                            Button {
                                round = min(round + 1, irvRounds.count - 1)
                            } label: {
                                Text("Add +")
                            }
                            
                        }
                        GeometryReader { geo in
                            Compass(election: facade, onCandidateMove: onCandidateMove)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .shadow(color: election.winningColor.opacity(0.9), radius: 300)
                        }
                        .aspectRatio(contentMode: .fit)


                        
                    default:
                        Text("Under construction...")
                    }
                }
                .padding(25)
            }
    }
}

