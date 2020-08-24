//
//  ContentView.swift
//  Reddit
//
//  Created by Carson Katri on 7/20/19.
//  Copyright © 2019 Carson Katri. All rights reserved.
//

import SwiftUI
import Request

struct ContentView : View {
    @State private var subreddit: String = "swift"
    @State private var sortBy: SortBy = .hot
    
    @State private var showSortSheet: Bool = false
    @State private var showSubredditSheet: Bool = false
    
    @State var history = ["iOSProgramming", "Apple", "macOSBeta"]
    
    var body: some View {
        NavigationView {
            /// Load the posts
            PostList(subreddit: subreddit, sortBy: sortBy)
            /// Force inline `NavigationBar`
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Button(action: {
                    self.showSubredditSheet.toggle()
                }) {
                    Text("r/\(self.subreddit)")
                }
            }, trailing: HStack {
                Button(action: {
                    self.showSortSheet.toggle()
                }) {
                    HStack {
                        Image(systemName: "arrow.up.arrow.down")
                        Text(self.sortBy.rawValue)
                    }
                }
            })
            /// Sorting method `ActionSheet`
            .actionSheet(isPresented: $showSortSheet) {
                ActionSheet(title: Text("Sort By:"), buttons: [SortBy.hot, SortBy.top, SortBy.new, SortBy.controversial, SortBy.rising].map { method in
                    ActionSheet.Button.default(Text(method.rawValue.prefix(1).uppercased() + method.rawValue.dropFirst())) {
                        self.sortBy = method
                    }
                })
            }
            /// Subreddit selection `Popover`
            .popover(isPresented: $showSubredditSheet, attachmentAnchor: .point(UnitPoint(x: 20, y: 20))) {
                Spacer()
                HStack(spacing: 0) {
                    Text("r/")
                    TextField("Subreddit", text: self.$subreddit) {
                        self.showSubredditSheet.toggle()
                        self.updateHistory()
                    }
                }
                .frame(width: 200)
                .padding()
                .background(Color("popover"))
                .cornerRadius(10)
                List {
                    ForEach(self.history, id: \.self) { history in
                            Button(action: {
                                self.subreddit = history
                                self.showSubredditSheet.toggle()
                                self.updateHistory()
                            })
                            {
                                Text(history)
                            }
                        }
                    }
            }
            Text("Select a post")
        }
    }
    
    func updateHistory() {
        if let historyPosition = history.firstIndex(of: subreddit)
        {
            history.remove(at: historyPosition)
            history.insert(self.subreddit, at: 0)
        } else {
            history.insert(self.subreddit, at: 0)
        }
        
    }
}
