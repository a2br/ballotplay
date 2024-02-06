//
//  GuideHeader.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

struct GuideHeader: View {
    @Binding var page: Page
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    // Menu
                    Text("hello bitch")
                } label: {
                    Image(systemName: "list.bullet")
                        .font(.system(.title3).bold())
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }
            .padding(10)
            Divider()
        }

    }
}
