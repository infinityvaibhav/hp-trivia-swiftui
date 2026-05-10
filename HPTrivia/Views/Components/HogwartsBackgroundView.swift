//
//  HogwartsBackgroundView.swift
//  HPTrivia
//
//  Created by वैभव उपाध्याय on 10/05/26.
//

import SwiftUI

struct HogwartsBackgroundView: View {
    let proxy: GeometryProxy
    var body: some View {
        Image(.hogwarts)
            .resizable()
            .frame(width: proxy.size.width * 3, height: proxy.size.height)
            .padding(.top)
            .phaseAnimator([false, true]) { content, phase in
                content
                    .offset(x: phase ? proxy.size.width/1.1 : -proxy.size.width/1.1)
            } animation: { _ in
                    .linear(duration: 60)
            }
    }
}

#Preview {
    GeometryReader { proxy in
        HogwartsBackgroundView(proxy: proxy)
    }
}
