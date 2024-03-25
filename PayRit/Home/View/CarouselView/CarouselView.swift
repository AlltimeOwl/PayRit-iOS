//
//  CarouselView.swift
//  PayRit
//
//  Created by 임대진 on 3/25/24.
//

import SwiftUI

struct CarouselView: View {
    @State private var pageIndex = 0
    let imageNames: [String] = ["speaker", "hand", "flag"]
    let label: [String] = ["어서와!\n처음인 너를 위해\n알려줄게", "차용증에 대해\n쉽게 알려드려요", "상대방님과\n상환완료\n축하드려요!"]
    let color: [Color] = [Color.payritMint, Color.payritIntensivePink, Color.payritMint]
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(imageNames.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(label[index])
                            .font(Font.title04)
                            .foregroundStyle(.white)
                        Button {
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
                .background(color[index])
                .clipShape(.rect(cornerRadius: 12))
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 190)
    }
}

#Preview {
    CarouselView()
}

struct PagingControl: UIViewRepresentable {
    var numberOfPages: Int // 전체 페이지 수
    var activePage: Int // 현재 활성화된 페이지
    
    func makeUIView(context: Context) -> UIPageControl {
        let pageControl = UIPageControl()
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPage = activePage
        pageControl.numberOfPages = numberOfPages
        pageControl.backgroundStyle = .prominent
        pageControl.currentPageIndicatorTintColor = UIColor(Color.primary)
        pageControl.pageIndicatorTintColor = UIColor.placeholderText
        
        return pageControl
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
}
