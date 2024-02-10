//
//  PageSelectorSection.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 09.02.2024.
//

import SwiftUI

struct PageSelectorSection: View {
    var range: Range<Int>
    @Binding var page: Page
        
    var body: some View {
        Section {
            ForEach(Page.allCases[range], id: \.rawValue) { p in
                PageSelector(p: p, page: $page)
            }
        }
    }
}

