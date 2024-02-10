//
//  State.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 10.02.2024.
//

import Foundation
import SwiftUI

// Order matters!
public enum Page: Int, Comparable, CaseIterable {
    public static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case plurality
    case spoilerEffect
    
    case irv
    case centerSqueeze
    
    case approval

}

// Order doesn't matter
public let pageNames: [Page: String] = [
    .plurality: "The Usual: Plurality",
    .spoilerEffect: "Spoiler Effect",
    
    .irv: "An Alternative: Instant Runoff",
    .centerSqueeze: "Center Squeeze",
    
    .approval: "An Outlier: Approval Voting"
]


func getPage(_ page: Page, plus: Int = 1) -> Page? {
    let currentIndex = page.rawValue
    let newIndex = currentIndex + plus
    return Page(rawValue: newIndex)
}

//TODO: Hey
var defaultElections: [Page: Election] = [
    .plurality: Election(),
    .spoilerEffect: Election(),
    
    .irv: Election(),
    .centerSqueeze: Election(),
    
    .approval: Election()
]

//TODO: Remove or implement?
class ElectionManager: ObservableObject {
    @Published var page: Page
    @Published var elections: [Page:Election]
    
    var election: Election {
        elections[page]!
    }
    
    init(page: Page = Page.allCases.first!) {
        self.elections = defaultElections
        self.page = page
    }
    
}
