//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 30/01/2024.
//

import SwiftUI

public var geo: GeometryProxy?

struct Compass: View {
    @Binding var election: Election
    
    var body: some View {
        GeometryReader(content: { geo in
            ZStack {
                Rectangle()
                    .fill(.thickMaterial)
                    .cornerRadius(15)
                ForEach($election.voters, id: \.id ) { $v in
                    VoterDot(voter: $v, color: .constant($v.wrappedValue.findClosest(candidates: $election.candidates.wrappedValue)?.color))
                        .position(mindToSpace(proxy: geo, opinion: $v.opinion.wrappedValue))
                }
                ForEach($election.candidates, id: \.id) { $c in
                    CandidateDot(candidate: $c)
                        .position(mindToSpace(proxy: geo, opinion: $c.opinion.wrappedValue))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    let pos = spaceToMind(proxy: geo, location: gesture.location)
                                    election.move(candidateId: c.id, newOpinion: pos)
                                }
                        )
                }
            }
        })
            
    }
}

#Preview {
    Compass(election: .constant(Election(candidates: Candidate.generate(count: 2))))
}
