//
//  Leaderboard.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 15.02.2024.
//

import SwiftUI


@available(iOS 17.0, *)
struct Leaderboard: View {
    @EnvironmentObject var election: Election

    @State var absoluteValues = false
    
    var body: some View {

        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.regularMaterial)
                    .onTapGesture {
                        absoluteValues.toggle()
                    }

                VStack {
                    
                    // If approval or plurality, it's simple!
                    let tally = election.votingSystem == .runoff
                    ? election.irvRounds()[election.round].pluralityTally()
                    :
                    election.votingSystem == .approval
                    ? election.approvalTally()
                    : election.pluralityTally()
                    let total = election.voters.count
                    
                    if election.votingSystem == .runoff {
                        
                        let rounds = election.irvRounds()
                        let round = rounds[election.round]
                        
                        let isFirst = election.round == 0
                        let isLast = election.round == rounds.count - 1
                        
                        
                        ZStack {
                            
                            HStack {
                                Spacer()
                                
                                Text("Round \(election.round + 1)")
                                
                                Spacer()
                            }
                            
                            HStack {
                                Button {
                                    election.round -= 1
                                } label: {
                                    Image(systemName: "chevron.backward")
                                    Text("Previous")
                                }
                                .disabled(isFirst)
                                
                                
                                Spacer()
                                
                                Button {
                                    election.round += 1
                                } label: {
                                    Text("Next")
                                    Image(systemName: "chevron.forward")
                                    
                                }
                                .disabled(isLast)
                                
                            }
                        }
                        
                        Divider()
                            .padding(.vertical, 10)
                    }
                    
                    HStack {
                        Text("#")
                            .padding(.trailing, 20)
                        
                        Text("Candidate")
                        
                        Spacer()
                        
                        Text(
                            (absoluteValues ? "# " : "% ") + (election.votingSystem == .approval ? "approvals" : "votes")
                        )
                        .monospaced()
                    }
                    .monospaced()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                    
                    ForEach(tally, id: \.key) { (candidate, count) in
                        HStack {
                            Text((tally.firstIndex(where: { candidate.id == $0.key.id })! + 1).description)
                                .padding(.trailing, 20)
                            Text(candidate.name)
                                .foregroundStyle(candidate.color)
                            Spacer()
                            
                            Text(
                                absoluteValues
                                ? "\(count)"
                                : "\((Double(count) / Double(total) * 100), specifier: "%.1f")%"
                            )
                            .monospaced()
                            .foregroundStyle(.secondary)
                        }
                    }
                    
                    // Still in VStack
                    if (election.votingSystem == .runoff) {
                        
                        let tally = election.irvRounds()[election.round].pluralityTally()
                        
                        let half = Double(election.voters.count) / 2
                        let overHalf = Double(tally.first!.value) >= half
                        
                        let head = tally.first!.key
                        let tail = tally.last!.key
                        
                        Group {
                            let subject = overHalf ? head : tail
                            
                            Text(subject.name)
                                .bold()
                                .foregroundStyle(subject.color)
                            
                            +
                            
                            (overHalf ?
                                Text(" wins with \(Double(tally.first!.value) / Double(election.voters.count) * 100, specifier: "%.1f")% of votes.")
                            : Text(" is eliminated."))
                            
                        }
                            .font(.footnote)
                            .padding(.top, 15)
                    }
                }
                .padding(20)
            }
            
            HStack {
                Group {
                    Image(systemName: "info.circle")
                    Text("Tap on the leaderboard to switch between relative and absolute metrics.")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                Spacer()
            }
            
        }
        .padding(.bottom, 20)
        Divider()
            .padding(.bottom, 20)


    }
}

