//
//  Color.swift
//  Ballot
//
//  Created by Anatole Debierre on 01/02/2024.
//

import Foundation
import SwiftUI

public var colorNames: [Color:(String,[String])] = 
    [
        .red: ("Red", ["Ronald", "Robert", "Raphael"]),
        .blue: ("Blue", ["Beatrice", "Bob", "Bella"]),
        .green: ("Green", ["Giovanni", "George", "Graham"]),
        .brown: ("Brown", ["Billy", "Ben", "Baptiste"]),
        .purple: ("Purple", ["Patricia", "Patrick", "Phoebe"]),
        .cyan: ("Cyan", ["Cindia", "Chloe", "Charlotte"]),
    ]

public func generateColorPair(not: [Color] = []) -> (Color, String) {
    // Remove some colors from pool
    let names = colorNames.filter { e in
        return !not.contains(e.key)
    }
    // Select color
    let elem = names.randomElement()!
    let color = elem.key
    
    let firstName = elem.value.1.randomElement()!
    let name = "\(firstName) \(elem.value.0)"
    
    return (color, name)
}
