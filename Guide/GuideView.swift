//
//  Guide.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI


@available(iOS 17.0, *)
struct GuideView: View {
    @Binding var page: Page
    @EnvironmentObject var election: Election
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .leading) {
                            switch page {
                            case .plurality:
                                PluralityPage()
                            case .spoilerEffect:
                                SpoilerPage()
                            case .irv:
                                RunoffPage()
                            case .centerSqueeze:
                                Text("Not finished yet!")
                            case .approval:
                                ApprovalPage()
                            }
                            Spacer()
                    }
                    .navigationTitle(pageNames[page]!)
                    .padding(30)
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
        .onChange(of: page) { old, new in
           
            // Set special boards
            
            let specialOld = specialElections[old]
            let specialNew = specialElections[new]
            
            if (specialOld != nil) {
                election.push(defaultE!)
            }
            if (specialNew != nil) {
                defaultE = election.copy()
                election.push(specialNew!)
            }
            
            // Set special voting system
            switch new {
            case .plurality, .spoilerEffect:
                election.votingSystem = .plurality
            case .irv, .centerSqueeze:
                election.votingSystem = .runoff
            case .approval:
                election.votingSystem = .approval
            }
        }
    }
}

