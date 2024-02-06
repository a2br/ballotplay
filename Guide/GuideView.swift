//
//  Guide.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI

public enum Page {
    case welcome
}

struct GuideView: View {
    @Binding var page: Page
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        // GuideHeader(page: $page)
                        Group {
                            switch page {
                            case .welcome:
                                WelcomePage()
                            }
                            Spacer()
                        }
                        .padding(25)
                        
                    }
                    Spacer()
                }
                .frame(
                    maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,
                    maxHeight: .infinity
                )
            }
        }
    }
}

