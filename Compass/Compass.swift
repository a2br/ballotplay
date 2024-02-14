//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 30/01/2024.
//

import SwiftUI
import TipKit


let ACCENTUATION = 0.5
let MIN_OPACITY = 0.4
let MAX_DIST_OPACITY = 2.squareRoot() * 2 - ACCENTUATION


@available(iOS 17.0, *)
struct Compass: View {
    @ObservedObject var election: Election
    @Binding var frameColor: Color

    var onCandidateMove: ((Candidate) -> Void)?
    
    let compassTip = CompassTip()
    
    init(election: Election, frameColor: Binding<Color> = .constant(.gray), onCandidateMove: ((Candidate) -> Void)? = nil) {
        self.election = election
        self._frameColor = frameColor
        self.onCandidateMove = onCandidateMove
    }
    
    var body: some View {
//        let _ = Tips.showAllTipsForTesting()
        
        GeometryReader(content: { geo in
            ZStack {
                Rectangle()
                    .fill(.background)
                    .cornerRadius(15)
                

                ForEach($election.voters, id: \.id ) { $v in
                    let closest = $v.wrappedValue.findClosest(candidates: election.activeCandidates)
                    let opacity = max(MIN_OPACITY, min(1.0, (MAX_DIST_OPACITY - $v.wrappedValue.distance(to: closest!)) / MAX_DIST_OPACITY
                    ))
                    VoterDot(
                        voter: $v,
                        color: .constant(
                            (
                            election.votingSystem == .approval
                            ? mixColors(election.approvalBallot(voter: $v.wrappedValue).map { $0.color })
                            : closest!.color.opacity(opacity)
                            )
                            ?? .primary.opacity(0.2))
                    )
                    .position(mindToSpace(proxy: geo, opinion: v.opinion))
                }
                if election.votingSystem == .approval {
                    ForEach($election.candidates, id: \.id) { $c in
                        let dim = 2 * mindToSpace(proxy: geo, distance: election.tolerance)
                        Circle()
                            .stroke($c.wrappedValue.color, lineWidth: 4)
                            .frame(width: dim, height: dim)
                            .position(mindToSpace(proxy: geo, opinion: $c.opinion.wrappedValue))
                            .clipped()
                    }
                }
                ForEach(
                    $election.candidates,
                    id: \.id
                ) { $c in
                    CandidateDot(candidate: $c, proxy: geo, onCandidateMove: onCandidateMove)
                }
                
                let pos = mindToSpace(proxy: geo, opinion: (0, -0.5))
                TipView(compassTip)
                    .frame(maxWidth: 300)
                    .position(CGPoint(x: pos.x + 10, y: pos.y + 10))
                    .zIndex(2)
                
                Rectangle()
                    .fill(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(frameColor, lineWidth: 4)
                    )
            }
        })
    }
}
