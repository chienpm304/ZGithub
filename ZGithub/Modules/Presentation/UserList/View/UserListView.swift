//
//  UserListView.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//
//

import SwiftUI
import NukeUI

struct UserListView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.dataModel.itemModels) { user in
                    UserRowView(
                        avatarURL: user.avatarURL,
                        title: user.name
                    ) {
                        if let blogURL = URL(string: user.blogURL) {
                            Link(user.blogURL, destination: blogURL)
                                .foregroundStyle(Color.blue)
                                .font(.callout)
                        } else {
                            Text(user.blogURL)
                                .underline()
                                .foregroundStyle(Color.blue)
                                .font(.callout)
                        }
                    }
                    .onTapGesture {
                        viewModel.didTapUserListItem(user)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Github Users")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onViewAppear()
        }
    }
}
