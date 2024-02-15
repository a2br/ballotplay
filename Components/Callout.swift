//
//  Callout.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 15.02.2024.
//

import SwiftUI

struct Callout: View {
    var color: Color = .orange
    var used: Bool = false

    var content: () -> Text
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.25))
            
            HStack {
                Image(systemName: "signpost.right.and.left.circle.fill")
                    .resizable()
                    .foregroundStyle(color)
                    .frame(width: 40, height: 40)
                    .padding(10)
                    .padding(.trailing, 40)

                VStack(alignment: .leading) {
                    content()
                        .bold()
                }
                
                Spacer()
            }
            .padding(15)
            
        }
        .saturation(used ? 0.15 : 1)
        .padding(.vertical, 30)
    }
}

