//
//  Guide.swift
//  Ballot
//
//  Created by Anatole Debierre on 29/01/2024.
//

import SwiftUI


struct NiceToolbar: ViewModifier {
    @Binding var page: Page
    
    func body(content: Content) -> some View {
        content.toolbar {
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

extension ScrollView {
    public func niceToolbar(page: Binding<Page>) -> some View {
        modifier(NiceToolbar(page: page))
    }
}

@available(iOS 17.0, *)
struct GuideView: View {
    @Binding var page: Page
    @EnvironmentObject var election: Election
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                            switch page {
                            case .plurality:
                                PluralityPage(page: $page)
                            case .spoilerEffect:
                                SpoilerPage(page: $page)
                            case .irv:
                                RunoffPage(page: $page)
                            case .centerSqueeze:
                                CenterSqueezePage(page: $page)
                            case .approval:
                                ApprovalPage(page: $page)
                            }

                            Spacer()
                    }
                    .navigationTitle(pageNames[page]!)
                    .padding(30)
                    Spacer()
                }
            }
            .niceToolbar(page: $page)
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

