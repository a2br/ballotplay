//
//  Compass.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

struct CompassView: View {
    @Binding var election: Election

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Group {
                    
                    Text("Green")
                        .foregroundColor(.green)
                    + Text(" is winning.")
                }
                    .font(.system(size: 35, weight: .bold))
                GeometryReader { geo in
                    Compass(election: $election)
                        .frame(width: geo.size.width, height: geo.size.width)
                }
                .aspectRatio(contentMode: .fit)
            }
            .padding(25)
        }
    }
}

//#Preview {
//    CompassView(election: .constant(Election(candidates: Candidate.generate(count: 2))))
//}
