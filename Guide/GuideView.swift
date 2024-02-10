//
//  Guide.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI


struct GuideView: View {
    @Binding var page: Page
    @EnvironmentObject var election: Election
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                        Group {
                            switch page {
                            case .plurality:
                                if #available(iOS 17.0, *) {
                                    PluralityPage(artificialCount: election.candidates.count)
                                } else { Text("This app is only available on iOS 17.0 or later.") }
                            default:
                                Text("Not finished yet!")
                            }
                            Spacer()
                        }
                        .navigationTitle(pageNames[page]!)
                        .padding(30)
                    }
                }
            }
            .animation(nil)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    
                    Menu {
                        PageSelectorSection(range: 0..<2, page: $page)
                        PageSelectorSection(range: 2..<4, page: $page)
                        PageSelector(p: Page.allCases[4], page: $page)
                        
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    HStack {
                        
                        let isFirst = page.rawValue == 0
                        let isLast = page.rawValue == Page.allCases.count - 1
                        
                        Button {
                            page = getPage(page, plus: -1)!
                        } label: {
                            Image(systemName: "chevron.backward")
                        }.disabled(isFirst)
                        
                        Button {
                            page = getPage(page, plus: +1)!
                        } label: {
                            Image(systemName: "chevron.forward")
                        }.disabled(isLast)
                    }
                }
            }
        }
    }
}

