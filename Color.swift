//
//  Color.swift
//  Ballot
//
//  Created by Anatole Debierre on 01/02/2024.
//

import Foundation
import SwiftUI
import UIKit

public var colorNames: [Color:(String,[String])] = 
    [
        .red: ("Red", ["Ronald", "Robert", "Raphael"]),
        .orange: ("Orange", ["Oscar", "Otto", "Octave"]),
        .blue: ("Blue", ["Beatrice", "Bob", "Bella"]),
        .green: ("Green", ["Giovanni", "George", "Graham"]),
        .purple: ("Purple", ["Patricia", "Patrick", "Phoebe"]),
        .cyan: ("Cyan", ["Cindia", "Chloe", "Charlotte"]),
    ]

public func generateColorPair(not: [Color] = []) -> (Color, String)? {
    // Remove some colors from pool
    let names = colorNames.filter { e in
        return !not.contains(e.key)
    }
    
    if names.count == 0 {
        return nil
    }
    
    // Select color
    let elem = names.randomElement()!
    let color = elem.key
    
    let firstName = elem.value.1.randomElement()!
    let name = "\(firstName) \(elem.value.0)"
    
    return (color, name)
}

public func generateMultipleColorPairs(_ n: Int) -> [(Color, String)] {
    var pairs: [(Color, String)] = []
    for _ in 1...n {
        pairs.append(generateColorPair(not: pairs.map { $0.0 })!)
    }
    return pairs
}


func mixColors(_ colors: [Color]) -> Color? {
    guard !colors.isEmpty else { return nil }
    
    var totalRed: CGFloat = 0
    var totalGreen: CGFloat = 0
    var totalBlue: CGFloat = 0
    var count: CGFloat = 0
    
    for color in colors {
        // Convert SwiftUI Color to UIColor
        let uiColor = UIColor(color)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        totalRed += red
        totalGreen += green
        totalBlue += blue
        count += 1
    }
    
    // Average the components
    let averageRed = totalRed / count
    let averageGreen = totalGreen / count
    let averageBlue = totalBlue / count
    
    // Create a new UIColor with the averaged components
    let mixedUIColor = UIColor(red: averageRed, green: averageGreen, blue: averageBlue, alpha: 1)
    
    // Convert UIColor back to SwiftUI Color
    return Color(mixedUIColor)
}
