//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 30/01/2024.
//

import SwiftUI


struct Compass: View {
    @ObservedObject var election: Election
    var onCandidateMove: ((Candidate) -> Void)?
    
    var actualCandidates: [Candidate] {
        election.candidates.filter { !$0.ghost }
    }
    
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
                    VoterDot(
                        voter: $v,
                        color: .constant((
                            election.votingSystem == .approval
                            ? mixColors(election.approvalBallot(voter: $v.wrappedValue).map { $0.color })
                            : $v.wrappedValue.findClosest(candidates: election.activeCandidates)?.color
                        ) ?? .primary.opacity(0.2))
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
            }
            .animation(nil)
        })
    }
}
//
//#Preview {
//    Compass(election: .constant(Election(candidates: Candidate.generate(count: 2))))
//}
