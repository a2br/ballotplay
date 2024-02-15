//
//  InlineCandidateName.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 15.02.2024.
//

import SwiftUI

struct InlineCandidateName: View {
    var candidate: Candidate
    
    var body: some View {
        Text(candidate.name)
            .bold()
            .foregroundStyle(candidate.color)
    }
}
