//
//  UserDetailView.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//  
//

import SwiftUI

struct UserDetailView: View {
    @ObservedObject private var viewModel: UserDetailViewModel

    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            userInfoSection
            followSection
            usernameSection
            blogSection
            Spacer()
        }
        .padding()
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.onViewAppear()
        }
    }

    @ViewBuilder
    var userInfoSection: some View{
        UserRowView(
            avatarURL: viewModel.dataModel.avatarURL,
            title: viewModel.displayName
        ) {
            HStack(spacing: 8) {
                Image(.icLocation)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .opacity(0.4)
                Text(viewModel.dataModel.location ?? "N/A")
                    .foregroundStyle(Color.gray)
            }
        }
    }

    @ViewBuilder
    private var followSection: some View {
        HStack {
            Spacer()

            FollowCountView(
                iconName: "person.2.fill",
                title: "Followers",
                count: viewModel.followers,
                countFormatFactory: viewModel.formatFollowCountFactory
            )

            Spacer()

            FollowCountView(
                iconName: "archivebox.fill",
                title: "Following",
                count: viewModel.following,
                countFormatFactory: viewModel.formatFollowCountFactory
            )

            Spacer()
        }
    }

    @ViewBuilder
    private var blogSection: some View {
        Text("Blog")
            .font(.title2)
            .fontWeight(.semibold)

        Text(viewModel.dataModel.blogURL)
            .foregroundStyle(Color.gray)
    }

    @ViewBuilder
    private var usernameSection: some View {
        Text("Username")
            .font(.title2)
            .fontWeight(.semibold)

        Text(viewModel.username)
            .foregroundStyle(Color.gray)
    }
}
