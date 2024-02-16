//
//  ApprovalPage.swift
//
//
//  Created by Anatole Debierre on 13.02.2024.
//

import SwiftUI


@available(iOS 17.0, *)
struct ApprovalPage: View {
    @Binding var page: Page

    @EnvironmentObject var election: Election
    
    @State var whatsNext: Bool = false
    
    var body: some View {
        
        VStack {
            ControlPanel()
            Leaderboard()
        }
    
        Text("Kenneth Arrow (our math guy) once said no voting system where you must give an order of preference will ever be perfect: this is Arrow’s Theorem.")
        
        Text("Approval Voting is a strange one —voters just tick candidates off, or they don’t. Surprisingly, it works pretty well.")
        
        Text("However, it is often criticized for its poor feasibility. What is keeping you from transforming this into a fancy Plurality election? Everyone would just have to tick only one box, and we’d be back to square one!")
        
        Text("For some reason, this is called the Chicken Dilemma.")
        
        // What's next button
        
        Button {
            whatsNext.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.accentColor)
                
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
            VStack {
                Spacer()

                Image(systemName: "globe.americas.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 40)
                    .foregroundColor(.accentColor)
                
                Text("So, what's next?")
                    .bold()
                    .font(.title)
                    .padding(.bottom, 50)
                
                // Elements
                SheetElem(icon: "scroll", color: .mint, text: "Advocacy for alternative voting is complex and may seem like a dead end: constitutions, often created to protect democracy, inherently block most updates to countries’ voting systems")
                
                SheetElem(icon: "gear.badge.questionmark", color: .indigo, text: "What even should we look for in our next voting system? Clarity and simple processes, like IRV or what Plurality already offers, or obscure algorithms with accurate outputs, such as the Condorcet Method?")
                
                
            }
            .padding(100)
        }
        
    }
        
}
