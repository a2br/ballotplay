//
//  ContentView.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var election = Election(candidates: Candidate.generate(count: 3))
    @State var page: Page = .welcome
    
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 0) {
                CompassView(election: election)
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                Divider()
                GuideView(page: $page)
//                    .frame(width: geo.size.width / 2, height: geo.size.height)
            }
        
        }
        .ignoresSafeArea()

    }
    
    func updatePosition(_ id: UUID, _ pos: Opinion) {
        for i in election.candidates.indices {
            if election.candidates[i].id == id {
                election.candidates[i].opinion = pos
                return
            }
        }
    }
}

#Preview {
    ContentView()
}
