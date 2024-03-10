//
//  PartnerInfoWritingView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct PartnerInfoWritingView: View {
    @Binding var path: NavigationPath
    @State private var isShowingStopAlert = false
    var body: some View {
        VStack {
            
            Spacer()
            NavigationLink {
                WritingCheckView(path: $path)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.mintColor)
                    .clipShape(.rect(cornerRadius: 12))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
        .padding(.bottom, 16)
        .navigationTitle("상대방 정보 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
        .toolbar {
            ToolbarItem {
                Button {
                    isShowingStopAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .PrimaryAlert(isPresented: $isShowingStopAlert,
                      title: "작성 중단",
                      content: """
                        지금 작성을 중단하시면
                        처음부터 다시 작성해야해요.
                        작성 전 페이지로 돌아갈까요?
                        """,
                      primaryButtonTitle: "아니오",
                      cancleButtonTitle: "네") {
        } cancleAction: {
            path = .init()
        }
    }
}

#Preview {
    NavigationStack {
        PartnerInfoWritingView(path: .constant(NavigationPath()))
    }
}
