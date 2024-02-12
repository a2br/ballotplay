//
//  CandidateDot.swift
//  Ballot
//
//  Created by Anatole Debierre on 03/02/2024.
//

import SwiftUI

public let CANDIDATE_SIZE: CGFloat = 40

struct CandidateDot: View {
    @Binding var candidate: Candidate
    var proxy: GeometryProxy
    
    var onCandidateMove: ((Candidate) -> Void)?
    
    @EnvironmentObject var election: Election
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(candidate.color.opacity(candidate.ghost ? 0.5 : 1))
                .saturation(candidate.locked ? 0.5 : 1)
                .cornerRadius(10)
            
            if candidate.locked {
                Image(systemName: "lock")
                    .bold()
                    .foregroundStyle(.background)
            }
        }
        .frame(width: CANDIDATE_SIZE, height: CANDIDATE_SIZE)
        .position(mindToSpace(proxy: proxy, opinion: candidate.opinion))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if (candidate.locked) { return }
                    
                    let pos = spaceToMind(proxy: proxy, location: gesture.location)
                    let posClamped = (min(1, max(-1, pos.0)), min(1, max(-1, pos.1)))
                    candidate.opinion = posClamped
                    onCandidateMove?(candidate)
                }
        )
    }
}

