//
//  ControlPanel.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 12.02.2024.
//

import SwiftUI

// Heavens forbid, this Panel will never find itself handling an election under oversight.
struct ControlPanel: View {
    @EnvironmentObject var election: Election

    
    var body: some View {
        let roundCount = Binding(
            get: { Double(election.round) },
            set: {
                election.round = Int($0)
            }
        )
        let maxCount = election.irvRounds().count
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
            
            VStack {
                Stepper("Number of candidates: \(election.candidateCount)", value: $election.candidateCount, in: 1...colorNames.count)
                    .padding(20)

                if (election.votingSystem == .runoff) {
                    Divider()
                    HStack {
                        Text("Round")
                        Spacer()
                        Slider(
                            value: roundCount,
                            in: maxCount == 1 ? -1...0 :  0...Double(maxCount - 1)
                        ) {
                        } minimumValueLabel: {
                            Text("1").font(.title2).fontWeight(.thin)
                        } maximumValueLabel: {
                            Text("\(maxCount)").font(.title2).fontWeight(.thin)
                        }
                        // WARN: Arbitrary number
                        .frame(maxWidth: 250)
                        .disabled(maxCount == 1)
                        .padding(.horizontal)
                    }
                    .padding()

                }

            }

            
        }
        
    }
}

