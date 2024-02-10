//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 30/01/2024.
//

import SwiftUI


struct Compass: View {
    @ObservedObject var election: Election

    
    var body: some View {
        GeometryReader(content: { geo in
            ZStack {
                Rectangle()
                    .fill(.background)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(election.winningColor, lineWidth: 4)
                    )
                ForEach($election.voters, id: \.id ) { $v in
                    VoterDot(voter: $v, color: .constant($v.wrappedValue.findClosest(candidates: $election.candidates.wrappedValue)?.color))
                        .position(mindToSpace(proxy: geo, opinion: v.opinion))
                }
                ForEach($election.candidates, id: \.self) { $c in
                    CandidateDot(candidate: $c, proxy: geo)
                }
                .animation(nil)

            }
        })
            
    }
}
//
//#Preview {
//    Compass(election: .constant(Election(candidates: Candidate.generate(count: 2))))
//}
