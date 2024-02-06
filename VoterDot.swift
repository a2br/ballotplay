//
//  VoterDot.swift
//  Ballot
//
//  Created by Anatole Debierre on 04/02/2024.
//

import SwiftUI

let VOTER_SIZE: CGFloat = 16

struct VoterDot: View {
    @Binding var voter: Voter
    @Binding var color: Color?
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(color?.opacity(0.5) ?? Color(white: colorScheme == .light ? 0.8 : 0.2))
            .frame(width: VOTER_SIZE, height: VOTER_SIZE)
    }
}

