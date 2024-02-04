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
    
    var body: some View {
        Rectangle()
            .fill(candidate.color)
            .frame(width: CANDIDATE_SIZE, height: CANDIDATE_SIZE)
            .cornerRadius(10)
    }
}

