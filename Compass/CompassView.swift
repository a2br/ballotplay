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
    
    @State var winningColor: Color = .gray
    
    // Creates an editable property that supports animations
    func setWinningColor(_ color: Color) {
        DispatchQueue.main.async {
            withAnimation(.easeIn(duration: 0.2)) {
                winningColor = color
                print("Setting winning color", color)
            }
        }
    }
    
    
    var irvRounds: [Election] {
        election.irvRounds()
    }
    
    var facade: Election {
        let irvRounds = irvRounds
        if (election.round >= irvRounds.count) {
            election.round = irvRounds.count - 1
        }
        return irvRounds[election.round]
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
        
        // Will step round count down when max is lowered
        election.round = min(election.round, irvRounds.count - 1)
    }
    
    var body: some View {
        VStack
            {
                Spacer()
                
                VStack(alignment: .leading) {
                    switch election.votingSystem {
                    case .plurality:
                        let winner = election.pluralityTally().first?.key
                        let _ = setWinningColor(winner?.color ?? .gray)
                        Group {
                            //Find who the fuck is winning
                            Text(winner?.name ?? "Nobody")
                                .foregroundColor(winner?.color ?? .gray)
                            + Text(" is winning with Plurality Voting.")
                        }
                        .font(.system(size: 35, weight: .bold))
                        
                        GeometryReader { geo in
                            Compass(election: election, frameColor: $winningColor)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .shadow(color: winningColor.opacity(0.9), radius: 300)
                        }
                        .aspectRatio(contentMode: .fit)
                    case .runoff:
                        let winner = irvRounds.last!.pluralityTally().first?.key
                        let _ = setWinningColor(winner?.color ?? .gray)
                        Group {
                            // Find who the fuck is winning
                            Text(winner?.name ?? "Nobody")
                                .foregroundColor(winner?.color ?? .gray)
                            + Text(" is winning with IRV after \(irvRounds.count) rounds.")
                        }
                        .font(.system(size: 35, weight: .bold))
                        
                        // Brand new election
                        HStack {
                            Button {
                                election.round = max(election.round - 1, 0)
                            } label: {
                                Text("Rem -")
                            }
                            
                            Text("Round: \(election.round + 1)/\(irvRounds.count)")
                            
                            Button {
                                election.round = min(election.round + 1, irvRounds.count - 1)
                            } label: {
                                Text("Add +")
                            }
                            
                        }
                        GeometryReader { geo in
                            Compass(election: facade, frameColor: $winningColor, onCandidateMove: onCandidateMove)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .shadow(color: winningColor.opacity(0.9), radius: 300)
                        }
                        .aspectRatio(contentMode: .fit)

                        
                    case .approval:
                        let winner = election.approvalTally().first?.key
                        let _ = setWinningColor(winner?.color ?? .gray)
                        Group {
                            //Find who the fuck is winning
                            Text(winner?.name ?? "Nobody")
                                .foregroundColor(winner?.color ?? .gray)
                            + Text(" is winning with Approval Voting.")
                        }
                        .font(.system(size: 35, weight: .bold))
                        
                        GeometryReader { geo in
                            Compass(election: election, frameColor: $winningColor)
                                .frame(width: geo.size.width, height: geo.size.width)
                                .shadow(color: winningColor.opacity(0.9), radius: 300)
                        }
                        .aspectRatio(contentMode: .fit)
                    }
                }
                .padding(25)
            }
    }
}

