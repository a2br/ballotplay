//
//  PluralityPage.swift
//
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

var seenSheet = true

@available(iOS 17.0, *)
struct PluralityPage: View {
    @Binding var page: Page
    
    @EnvironmentObject var election: Election
    @State private var showSheet: Bool = !seenSheet
    
    var body: some View {
        
            Rectangle()
                .frame(width: 0, height: 0)
                .sheet(isPresented: $showSheet, onDismiss: {
                    seenSheet = true
                    showSheet = false
                }) {
                    VStack {
                        Text("Welcome to BallotPlay!")
                            .bold()
                            .font(.title)
                            .padding(.bottom, 50)
                        
                        // Elements
                        SheetElem(icon: "key", color: .orange, text: "Welcome to this app all about voting systems: a fascinating and powerful tool that decides who gets the key to public office and who does not.")
                        
                        SheetElem(icon: "lasso.badge.sparkles", color: .purple, text: "BallotPlay helps you understand their strengths and flaws by representing the political compass, where you can move candidates and see who people vote for through their color.")
                        
                        SheetElem(icon: "speaker.zzz.fill", color: .cyan, text: "My goal is to encourage public debate on this silent, but crucial issue at the heart of democracy. Enjoy!")
                        

                        Spacer()
                        Button {
                            showSheet = false
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentColor)

                                Text("I'm ready!")
                                    .bold()
                                    .foregroundStyle(.white)
                                    .padding(20)
                            }
                            .frame(maxHeight: 50)
                        }
                    }
                    .padding(100)

                }
        
            VStack {
                ControlPanel()
                Leaderboard()
            }
        
            Text(
                """
                Plurality voting is the most widely used voting system. It is hard to think of something more intuitive: “Just pick the candidate you like best.”
                """
            )
        
            Text(
                """
                Feel free to play around with this election. When you’re ready, let’s take a look at why it may not be enough…
                """
            )
        
        NextButton(page: $page)
    


    }
    
}
