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

var defaultE: Election?

let sC = generateMultipleColorPairs(3)
let sD = generateMultipleColorPairs(3)


public let specialElections: [Page: Election] = [
    .spoilerEffect: Election(
        votingSystem: .plurality,
        candidates: [
            Candidate(opinion: (-0.5, -0.5), name: sC[0].1, color: sC[0].0, locked: true),
            Candidate(opinion: (0.2, 0.25), name: sC[1].1, color: sC[1].0, locked: true),
            Candidate(opinion: (1, -1), name: sC[2].1, color: sC[2].0, locked: false)
        ]
    ),
    .centerSqueeze: Election(
        votingSystem: .runoff,
        candidates: [
            Candidate(opinion: (-0.25, -0.25), name: sD[0].1, color: sD[0].0, locked: true),
            Candidate(opinion: (0.2, 0.2), name: sD[1].1, color: sD[1].0, locked: true),
            Candidate(opinion: (0.4, 0.4), name: sD[2].1, color: sD[2].0, locked: false)
        ]
    )
]

