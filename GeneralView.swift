//
//  GeneralView.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

struct GeneralView: View {
    @State var page: Page = Page.allCases.first!
    var election = Election(candidates: Candidate.generate(count: 3))
    
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 0) {
                CompassView()
                    .environmentObject(election)
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                Divider()
                GuideView(page: $page)
                    .environmentObject(election)
//                    .frame(width: geo.size.width / 2, height: geo.size.height)
            }
        
        }
        .ignoresSafeArea()

    }
}
