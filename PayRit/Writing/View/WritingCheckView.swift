//
//  WritingCheckView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct WritingCheckView: View {
    let document: Document = Document.samepleDocument[0]
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingKaKaoAlert: Bool = false
    @State private var isShowingDoneAlert: Bool = false
    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // 내용 상세
            HStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("거래 금액")
                    }
                    HStack {
                        Text("거래 날짜")
                    }
                    HStack {
                        Text("상환 마감일")
                    }
                }
                .bold()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(document.totalMoney) 원")
                    }
                    HStack {
                        Text("\(document.startDay)")
                    }
                    HStack {
                        Text("\(document.endDay)")
                    }
                }
                Spacer()
            }
            .padding(20)
            .background(Color.boxGrayColor)
            .clipShape(.rect(cornerRadius: 12))
            
            VStack(alignment: .leading) {
                Text("빌려준 사람")
                    .foregroundStyle(Color.sectionTitleColor)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("이름")
                        }
                        HStack {
                            Text("연락처")
                        }
                        HStack {
                            Text("주소")
                        }
                    }
                    .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(document.sender)")
                        }
                        HStack {
                            Text("\(document.senderPhoneNumber)")
                        }
                        HStack {
                            Text("\(document.senderAdress)")
                        }
                    }
                    Spacer()
                }
                .padding(20)
                .background(Color.boxGrayColor)
                .clipShape(.rect(cornerRadius: 12))
            }
            
            // 빌린 사람 정보
            VStack(alignment: .leading) {
                Text("빌린 사람")
                    .foregroundStyle(Color.sectionTitleColor)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                HStack(alignment: .center, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("이름")
                        }
                        HStack {
                            Text("연락처")
                        }
                        HStack {
                            Text("주소")
                        }
                    }
                    .bold()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(document.recipient)")
                        }
                        HStack {
                            Text("\(document.recipientPhoneNumber)")
                        }
                        HStack {
                            Text("\(document.recipientAdress)")
                        }
                    }
                    Spacer()
                }
                .padding(20)
                .background(Color.semeMintColor)
                .clipShape(.rect(cornerRadius: 12))
            }
            Spacer()
            Button {
                isShowingKaKaoAlert.toggle()
            } label: {
                Text("요청 전송")
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.mintColor)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.bottom, 16)
        }
        .padding(.top, 30)
        .padding(.horizontal, 16)
        .font(.system(size: 18))
        .navigationTitle("차용증 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
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
        .PrimaryAlert(isPresented: $isShowingKaKaoAlert,
                      title: "카카오톡 요청 전송",
                      content: """
                        요청 메시지를
                        전송하시겠습니까?
                        """,
                      primaryButtonTitle: "네",
                      cancleButtonTitle: "아니오") {
            isShowingDoneAlert.toggle()
        } cancleAction: {
        }
        .PrimaryAlert(isPresented: $isShowingDoneAlert,
                      title: "카카오톡 요청 완료",
                      content: """
                        상대방에게 카카오톡으로 요청이
                        완료되었습니다.
                        """,
                      primaryButtonTitle: nil,
                      cancleButtonTitle: "확인",
                      primaryAction: nil) {
            path = .init()
        }
    }
}

#Preview {
    NavigationStack {
        WritingCheckView(path: .constant(NavigationPath()))
    }
}
