//
//  UserListView.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import SwiftUI

struct UserListView: View {
    @ObservedObject private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(viewModel.dataModel.itemModels) { user in
                        HStack {
                            Button {
                                viewModel.didTapUserListItem(user)
                            } label: {
                                HStack {
                                    AsyncImage(url: URL(string: user.avatarURL)) { image in
                                        image
                                            .frame(width: 120, height: 120)
                                    } placeholder: {
                                        Image(.icDefaultAvatar)
                                            .frame(width: 120, height: 120)
                                    }
                                    .frame(width: 128, height: 128)
                                    .border(.gray)

                                    VStack {
                                        Text(user.name)
                                            .foregroundColor(.primary)
                                        Divider()
                                        Text(user.blogURL) // TODO: generic view
                                            .foregroundStyle(Color.blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Github Users")
        .navigationBarTitleDisplayMode(.inline)
//        .resultAlert(alertData: $viewModel.alertData)
        .task {
            await viewModel.onViewAppear()
        }
    }
}
