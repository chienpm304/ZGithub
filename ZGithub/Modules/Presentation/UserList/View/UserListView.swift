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
                ForEach(viewModel.itemModels) { user in
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
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        viewModel.didTapUserListItem(user)
                    }
                    .onAppear {
                        Task { @MainActor in
                            await viewModel.onAppearUserListItem(user)
                        }
                    }
                }

                footerView
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Github Users")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onViewAppear()
        }
    }

    @ViewBuilder
    private var footerView: some View {
        HStack {
            Spacer()
            if viewModel.isLoading {
                Text("Loading...")
                    .font(.callout)
                    .foregroundStyle(Color.gray)
            } else if !viewModel.hasMore {
                Text("You've reached the viewing limit. Upgrade to preview more 😊")
                    .font(.callout)
                    .foregroundStyle(Color.gray)
            } else {
                Text("Something went wrong!!")
                    .font(.callout)
                    .foregroundStyle(Color.red)
            }

            Spacer()
        }
    }
}
