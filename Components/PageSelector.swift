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
            Label(pageNames[p]!, systemImage: isCurrent ? "checkmark" : "")
        }.disabled(isCurrent)
    }
}
