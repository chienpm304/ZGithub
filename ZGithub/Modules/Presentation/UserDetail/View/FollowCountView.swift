//
//  FollowStatView.swift
//  ZGithub
//
//  Created by Chien Pham on 6/10/24.
//
//

import SwiftUI

struct FollowCountView: View {
    let iconName: String
    let title: String
    let count: Int
    let countFormatFactory: ((Int) -> String)?

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .frame(width: 48, height: 48)
                .background(Color.gray.opacity(0.2))
                .clipShape(Circle())

            Text(displayCountString)
                .fontWeight(.semibold)

            Text(title)
        }
    }

    var displayCountString: String {
        if let countFormatFactory {
            return countFormatFactory(count)
        } else {
            return "\(count)"
        }
    }
}
