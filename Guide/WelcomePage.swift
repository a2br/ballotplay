//
//  WelcomePage.swift
//
//
//  Created by Anatole Debierre on 06.02.2024.
//

import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(1...5, id: \.self) { _ in
                VStack(alignment: .leading) {
                    ForEach(1...10, id: \.self) {
                        Text("Row \($0)")
                    }
                }
                .padding(.vertical, 5)
                .monospaced()
            }
        }
        .navigationTitle("When Democracy Glitches.")
    }
}
