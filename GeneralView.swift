//
//  GeneralView.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct GeneralView: View {
    @State var page: Page = Page.allCases.first!
    var election = Election(candidates: Candidate.generate(count: 3))
    
    var body: some View {
        GeometryReader { geo in
            
            HStack(spacing: 0) {
                GuideView(page: $page)
                    .environmentObject(election)
                Divider()
                CompassView()
                    .environmentObject(election)
                    .frame(width: geo.size.width / 2, height: geo.size.height)
                    .zIndex(-1.0)
                
            }
        
        }
        .ignoresSafeArea()

    }
}
