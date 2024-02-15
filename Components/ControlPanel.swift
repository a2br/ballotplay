//
//  ControlPanel.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 12.02.2024.
//

import SwiftUI

let PRACTICAL_MAX_TOLERANCE = 2.squareRoot() + 0.01

// Heavens forbid, this Panel will never find itself handling an election under oversight.
struct ControlPanel: View {
    @EnvironmentObject var election: Election

    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
            
            VStack {
                Stepper("Number of candidates: \(election.candidateCount)", value: $election.candidateCount, in: 1...colorNames.count)


                if (election.votingSystem == .approval) {
                    Divider()
                        .padding(.vertical, 10)
                    HStack {
                        Text("Tolerance: \((election.tolerance / PRACTICAL_MAX_TOLERANCE) * 100, specifier: "%.0f")%")
                        Spacer()
                        Slider(
                            value: $election.tolerance,
                            in: 0.2...PRACTICAL_MAX_TOLERANCE
                        )
                        .frame(maxWidth: 250)
                    }
                }

            }
            .padding(20)

            
        }
        
    }
}

