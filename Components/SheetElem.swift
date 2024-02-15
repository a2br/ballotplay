//
//  SheetElem.swift
//  BallotPlay
//
//  Created by Anatole Debierre on 15.02.2024.
//

import SwiftUI

struct SheetElem: View {
    var icon: String
    var color: Color
    
    var text: String
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(20)
                    .foregroundStyle(color)
                
                Spacer()
            }
            
            Text(text)
                .padding(.leading, 110)
        }
    }
}
