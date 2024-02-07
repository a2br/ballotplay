//
//  Block.swift
//
//
//  Created by Anatole Debierre on 07.02.2024.
//

import SwiftUI

public func Block(_ inside: () -> some View) -> some View {
    VStack {
        inside()
    }
    .padding(.vertical, 10)



}
