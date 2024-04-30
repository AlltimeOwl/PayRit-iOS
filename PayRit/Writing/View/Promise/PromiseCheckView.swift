//
//  PromiseCheckView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI
import FirebaseAnalytics

struct PromiseCheckView: View {
    let contacts: [Contacts]
    let writingStore: WritingStore = WritingStore()
    @State var promise: Promise
    @State private var promiseId: String = ""
    @State private var isShowingDoneAlert: Bool = false
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingKaKaoAlert: Bool = false
    @State private var isShowingErrorAlert: Bool = false
    @Binding var path: NavigationPath
    @Environment(MyPageStore.self) var mypageStore
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(PromiseImage.allCases, id: \.self) { item in
                        Button {
                            promise.promiseImageType = item
                        } label: {
                            Image(item.rawValue)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                }
                .frame(height: 55)
                .padding(.top, 20)
            }
            .scrollIndicators(.hidden)
            
            ScrollView {
                Image(promise.promiseImageType.rawValue)
                    .padding(.top, 36)
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("약속 정보")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        InfoBox(title: "금액", text: .constant(String(promise.amount)))
                        InfoBox(title: "기간", text: .constant("\(promise.promiseStartDate.hyphenFomatter().replacingOccurrences(of: "-", with: "."))~\(promise.promiseEndDate.hyphenFomatter().replacingOccurrences(of: "-", with: "."))"))
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
                        InfoBox(title: "이름", text: .constant(promise.writerName), type: .long)
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
                        ForEach(contacts) { contact in
                            InfoBox(title: "이름|연락처", text: .constant("\(contact.name) | \(contact.phoneNumber.notHyphen())"), type: .long)
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
                            Text(promise.contents)
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
            .scrollIndicators(.hidden)
            
            Button {
                Analytics.logEvent("write_Promise_iOS", parameters: [
                    "amount": String(promise.amount)
                ])
                writingStore.savePromise(promise: promise, contacts: contacts) { result in
                    if let result = result {
                        promiseId = result
                        isShowingKaKaoAlert.toggle()
                    } else {
                        isShowingErrorAlert.toggle()
                    }
                }
            } label: {
                Text("저장하기")
                    .font(Font.title04)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.payritMint)
                    .clipShape(.rect(cornerRadius: 12))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("약속 카드 만들기")
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
        .primaryAlert(isPresented: $isShowingStopAlert,
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
        .primaryAlert(isPresented: $isShowingDoneAlert,
                      title: "작성 완료",
                      content: """
                        작성이 완료되었습니다.
                        """,
                      primaryButtonTitle: nil,
                      cancleButtonTitle: "확인") {
        } cancleAction: {
            path = .init()
        }
        .primaryAlertNoneTouch(isPresented: $isShowingKaKaoAlert,
                      title: "카카오톡 공유",
                      content: """
                        약속 카드를
                        카카오톡으로 공유할까요?
                        """,
                      primaryButtonTitle: "네",
                      cancleButtonTitle: "아니오") {
            
            if let promiseId = Int(promiseId) {
                KakaoShareService().promiseKakaoShare(id: promiseId, sender: promise.writerName) { kakaoLinkType in
                    KakaoShareService().openKakaoLink(kakaoLinkType: kakaoLinkType) {
                    }
                }
            }
            
            path = .init()
        } cancleAction: {
            path = .init()
        }
        .primaryAlert(isPresented: $isShowingErrorAlert,
                      title: "에러",
                      content: """
                        약속 카드 작성에 실패하였습니다
                        다시 시도하여 주세요
                        """,
                      primaryButtonTitle: nil,
                      cancleButtonTitle: "확인",
                      primaryAction: nil) {
        }
    }
}

//#Preview {
//    NavigationStack {
//        PromiseCheckView(contacts: [Contacts](), promise: Promise(amount: 0, promiseStartDate: Date(), promiseEndDate: Date(), contents: "", participants: [Participants](), promiseImageType: .HEART), path: .constant(NavigationPath()))
//    }
//}
