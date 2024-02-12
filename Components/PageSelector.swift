//
//  PageSelector.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 09.02.2024.
//

import SwiftUI

struct PageSelector: View {
    var p: Page
    @Binding var page: Page
    
    var body: some View {
        let isCurrent = p == page
        Button {
            page = p
        } label: {
            if isCurrent {
                Label(pageNames[p]!, systemImage: "checkmark")
            } else {
                Text(pageNames[p]!)
            }
        }.disabled(isCurrent)
    }
}
