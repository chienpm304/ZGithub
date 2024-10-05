//
//  UserRowView.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import SwiftUI

struct UserRowView<Content: View>: View {
    private let avatarURL: String
    private let title: String
    private let extraContent: (() -> Content)?

    init(
        avatarURL: String,
        title: String,
        @ViewBuilder extraContent: @escaping () -> Content
    ) {
        self.avatarURL = avatarURL
        self.title = title
        self.extraContent = extraContent
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            UserAvatarView(avatarURL: avatarURL)

            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .padding(.top, 8)

                Divider()

                extraContent?()
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 4)
        )
    }
}
