//
//  CarouselView.swift
//  PayRit
//
//  Created by 임대진 on 3/25/24.
//

import SwiftUI

struct CarouselView: View {
    let hasCompleted: Bool
    @State private var pageIndex = 0
    @State private var isShowingSheet: Bool = false
    let imageNames: [String] = ["flag", "speaker", "hand"]
    let label: [String] = ["상환완료\n축하드려요!", "어서와!\n처음인 너를 위해\n알려줄게", "차용증에 대해\n쉽게 알려드려요"]
    let color1: [Color] = [Color.payritMint, Color.payritMint, Color.payritIntensivePink]
    let color2: [Color] = [Color.payritMint, Color.payritIntensivePink, Color.payritMint]
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(hasCompleted ? imageNames.indices : imageNames.indices.dropFirst(), id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(label[index])
                            .font(Font.title04)
                            .foregroundStyle(.white)
                        Button {
                            isShowingSheet.toggle()
                        } label: {
                            Text("보러가기 >")
                                .font(Font.body01)
                                .foregroundStyle(.white)
                        }
                    }
                    Spacer()
                    Image(imageNames[index])
                }
                .tag(index)
                .padding(20)
                .frame(maxWidth: .infinity)
                .frame(height: 190)
                .background(hasCompleted ? color2[index] : color1[index])
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 190)
        .fullScreenCover(isPresented: $isShowingSheet) {
            if let url = URL(string: "https://payrit.info") {
                SafariView(url: url)
            }
        }
    }
    
}

#Preview {
    CarouselView(hasCompleted: false)
}
