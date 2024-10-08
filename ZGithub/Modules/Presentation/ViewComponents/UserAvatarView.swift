//
//  UserAvatarView.swift
//  ZGithub
//
//  Created by Chien Pham on 5/10/24.
//  
//

import SwiftUI
import NukeUI

struct UserAvatarView: View {
    let avatarURL: String

    var body: some View {
        LazyImage(url: URL(string: avatarURL)) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            } else if state.isLoading {
                ProgressView()
            } else {
                Image(.icDefaultAvatar)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
            }
        }
        .processors([.resize(width: 80)])
        .priority(.high)
        .frame(width: 80, height: 80)
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "f7f7f7"))
        )
    }
}
