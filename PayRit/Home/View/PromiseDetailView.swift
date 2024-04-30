//
//  PromiseDetailView.swift
//  PayRit
//
//  Created by 임대진 on 4/28/24.
//

import SwiftUI

struct PromiseDetailView: View {
    @State var detail: Promise
    @State var isShowingDeleteAlert: Bool = false
    @Binding var isDelete: Int
    @Environment(MyPageStore.self) var mypageStore
    @Environment(HomeStore.self) var homeStore
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("약속 정보")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        InfoBox(title: "금액", text: .constant("\(detail.amount.amountFormatter())원"))
                        InfoBox(title: "기간", text: .constant("\(detail.promiseStartDate.dotFomatter())~\(detail.promiseEndDate.dotFomatter())"))
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
                        InfoBox(title: "이름", text: .constant("\(detail.writerName)"), type: .long)
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
                        ForEach(detail.participants, id: \.self) { item in
                            InfoBox(title: "이름|연락처", text: .constant("\(item.participantsName)|\(item.participantsPhone)"), type: .long)
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 20)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 12))
                    .customShadow()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("약속 내용")
                            .font(Font.body03)
                            .foregroundStyle(Color.payritMint)
                        HStack {
                            Text(detail.contents)
                                .font(Font.body01)
                            Spacer()
                        }
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
            .onAppear {
                UITableView.appearance().refreshControl = nil
            }
            VStack {
                Button {
                    KakaoShareService().promiseKakaoShare(id: detail.promiseId, sender: detail.writerName) { kakaoLinkType in
                        KakaoShareService().openKakaoLink(kakaoLinkType: kakaoLinkType) {
                        }
                    }
                } label: {
                    Text("공유 하기")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: 12))
                }
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .navigationTitle("약속 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingDeleteAlert.toggle()
                } label: {
                    Image("trashIcon")
                        .foregroundStyle(Color.gray06)
                }
            }
        }
        .primaryAlert(isPresented: $isShowingDeleteAlert, title: "약속 삭제", content: "정말 삭제하시겠습니까?\n복구할 수 없습니다.", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            self.presentation.wrappedValue.dismiss()
            homeStore.promiseDelete(id: detail.promiseId) { result in
                if result {
                    isDelete = detail.promiseId
                }
            }
        } cancleAction: {
        }
    }
}

#Preview {
    NavigationStack {
        PromiseDetailView(detail: Promise(promiseId: 0, amount: 0, promiseStartDate: Date(), promiseEndDate: Date(), writerName: "", contents: "", participants: [Participants](), promiseImageType: .BOOK, isClicked: false), isDelete: .constant(0))
            .environment(HomeStore())
            .environment(MyPageStore())
    }
}
