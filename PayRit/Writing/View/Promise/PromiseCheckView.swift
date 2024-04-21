//
//  PromiseCheckView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI

struct PromiseCheckView: View {
    @State private var seletedImage = "card1"
    @Binding var path: NavigationPath
    let images = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8", "card9"]
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(images, id: \.self) { item in
                        Button {
                            seletedImage = item
                        } label: {
                            Image(item)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .frame(height: 55)
            }
            .scrollIndicators(.hidden)
            
            ScrollView {
                Image(seletedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 340)
                    .padding(.top, 36)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("약속 정보")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        InfoBox(title: "금액", text: .constant(""), type: .long)
                        InfoBox(title: "기간", text: .constant(""), type: .long)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 12))
                    .customShadow()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("보낸 사람")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        InfoBox(title: "금액", text: .constant(""), type: .long)
                        InfoBox(title: "기간", text: .constant(""), type: .long)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 12))
                    .customShadow()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("받는 사람")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        InfoBox(title: "금액", text: .constant(""), type: .long)
                        InfoBox(title: "기간", text: .constant(""), type: .long)
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 12))
                    .customShadow()
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 16)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    PromiseCheckView(path: .constant(NavigationPath()))
}
