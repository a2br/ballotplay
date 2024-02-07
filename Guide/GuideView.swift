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

public let pageNames: [Page: String] = [
    .welcome: "Welcome"
]

struct GuideView: View {
    @Binding var page: Page
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            switch page {
                            case .welcome:
                                WelcomePage()
                            }
                            Spacer()
                        }
                        .padding(30)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu {
                        Text("Hello")
                        Text("Hello")
                        Text("Hello")
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            Spacer()
            GuideBar(page: $page)
        }
    }
}

