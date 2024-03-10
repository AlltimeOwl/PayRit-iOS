//
//  MyInfoWritingView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct MyInfoWritingView: View {
    @State var test = ""
    @State private var isShowingStopAlert = false
    @Binding var path: NavigationPath
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading) {
                    Text("이름")
                    HStack {
                        TextField(text: $test) {
                            Text("임대진")
                        }
                        Spacer()
                        Image(systemName: "xmark.circle")
                    }
                    Divider()
                }
                VStack(alignment: .leading) {
                    Text("연락처")
                    HStack {
                        TextField(text: $test) {
                            Text("010-5009-7937")
                        }
                        Spacer()
                        Image(systemName: "xmark.circle")
                    }
                    Divider()
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("주소")
                    HStack {
                        VStack {
                            Text(" ")
                            Divider()
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Text("우편번호 검색")
                                .foregroundStyle(.black)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color(hex: "EAEAEA"))
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                    Text(" ")
                    Divider()
                    Text(" ")
                    Divider()
                }
                Spacer()
                NavigationLink {
                    PartnerInfoWritingView(path: $path)
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
        }
        .padding(.horizontal, 16)
        .padding(.top, 30)
        .padding(.bottom, 16)
        .navigationTitle("내 정보 작성하기")
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
        MyInfoWritingView(path: .constant(NavigationPath()))
    }
}
