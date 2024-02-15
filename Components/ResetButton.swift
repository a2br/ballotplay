//
//  ResetButton.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 15.02.2024.
//

import SwiftUI

struct ResetButton: View {
    @EnvironmentObject var election: Election
    var target: Page
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.regularMaterial)
            
            HStack {
                
                Button {
                    election.push(specialElections[target]!)
                } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                
                Spacer()
        
            }
            .padding(20)
        }
    }
}

