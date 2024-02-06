//
//  Guide.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

struct GuideView: View {
    @Binding var page: Int
    
    var body: some View {
        HStack {
            
            
            VStack(alignment: .leading) {
                switch page {
                case 0:
                    WelcomePage()
                default:
                    Text("I'm sorry, an error came up.")
                }
                Spacer()
            }
            Spacer()
        }
            .padding(25)
            .frame(
                maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                maxHeight: .infinity
            )

        
    }
}

