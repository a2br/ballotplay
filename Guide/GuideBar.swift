//
//  GuideBar.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

struct GuideBar: View {
    @Binding var page: Page
    
    
    var body: some View {
        let pageName = pageNames[page]!
        
        let i = pageNames.keys.distance(
            from: pageNames.keys.startIndex,
            to: pageNames.keys.firstIndex(of: page)!
        )
        
        let isFirst = i == 0
        let isLast = i == pageNames.count - 1

        VStack {
            Divider()
            
            HStack {
                
                Button {
                    print("left")
                } label: {
                    Image(systemName: "chevron.left")
                }.disabled(isFirst)
                
                Spacer()
                
                Menu {
                    // Menu
                    Text("Hello")
                } label: {
                    Label(pageName, systemImage: "list.bullet")
                }
                
                Spacer()
                
                Button() {
                    print("right")
                } label: {
                    Image(systemName: "chevron.right")
                }.disabled(!isLast)
                
            }
            .padding(10)
        }

    }
}
