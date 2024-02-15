//
//  ApprovalPage.swift
//
//
//  Created by Anatole Debierre on 13.02.2024.
//

import SwiftUI


@available(iOS 17.0, *)
struct ApprovalPage: View {
    @EnvironmentObject var election: Election
    
    @State var whatsNext: Bool = false
    
    var body: some View {
        
        ControlPanel()
        Leaderboard()
    
        Text("Kenneth Arrow (our math guy) once said no voting system where you must give an order of preference will ever be perfect: this is Arrow’s Theorem.")
        .block()
        
        Text("Approval Voting is a strange one —voters just tick candidates off, or they don’t. Surprisingly, it works pretty well.")
            .block()
        
        Text("However, it is often criticized for its poor feasibility. What is keeping you from transforming this into a glittery version of Plurality? Everyone would just have to tick only one box, and we’d be back to square one!")
            .block()
        
        Text("For some reason, this is called the Chicken Dilemma.")
            .block()
        
        // What's next button
        
        Button {
            whatsNext.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.blue)
                
                HStack {
                    Text("So, what's next?")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(20)
                }
            }
            .padding(.vertical, 0)
            .padding(.horizontal, 0)
        }
        .sheet(isPresented: $whatsNext) {
            Text("hi from whats next")
        }
        
    }
        
}
