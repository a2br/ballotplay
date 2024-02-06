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
    
    var body: some View {
        Rectangle()
            .fill(candidate.color)
            .frame(width: CANDIDATE_SIZE, height: CANDIDATE_SIZE)
            .cornerRadius(10)
            .position(mindToSpace(proxy: proxy, opinion: candidate.opinion))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let pos = spaceToMind(proxy: proxy, location: gesture.location)
                        let posClamped = (min(1, max(-1, pos.0)), min(1, max(-1, pos.1)))
                        candidate.opinion = posClamped
                    }
            )
    }
}

