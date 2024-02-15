//
//  Tips.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 14.02.2024.
//

import SwiftUI
import TipKit


struct CompassTip: Tip {
    var id: String = "compass-tip"
    
    var title: Text {
        Text("Political Compass")
    }
    
    var message: Text? {
        Text("Move candidates around on the political compass, and voters will change colors.")
    }
    
    var image: Image? {
        Image(systemName: "hand.point.up.fill")
    }
}
