//
//  WritingCheckView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

enum SaveType {
    case save
    case pix
}
struct SaveInfo {
    let type: SaveType
    let id: Int?
}

struct WritingCheckView: View {
    let saveType: SaveInfo
    let writingStore: WritingStore
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingKaKaoAlert: Bool = false
    @State private var isShowingErrorAlert: Bool = false
    @Binding var path: NavigationPath
    @Binding var newCertificate: CertificateDetail
    @Environment(HomeStore.self) var homeStore
    @Environment(TabBarStore.self) var tabStore
    @Environment(MyPageStore.self) var mypageStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("거래내역")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            InfoBox(title: "금액", text: .constant("\(newCertificate.paperFormInfo.primeAmountFomatter)원"), type: .long)
                            InfoBox(title: "원금 상환일", text: .constant("\(newCertificate.paperFormInfo.repaymentEndDate)"), type: .long)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("빌려준 사람")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            InfoBox(title: "이름", text: .constant("\(newCertificate.creditorProfile.name)"))
                            InfoBox(title: "연락처", text: .constant("\(newCertificate.creditorProfile.phoneNumber)"))
                            if !newCertificate.creditorProfile.address.isEmpty {
                                InfoBox(title: "주소", text: .constant("\(newCertificate.creditorProfile.address)"))
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("빌린 사람")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            InfoBox(title: "이름", text: .constant("\(newCertificate.debtorProfile.name)"))
                            InfoBox(title: "연락처", text: .constant("\(newCertificate.debtorProfile.phoneNumber)"))
                            if !newCertificate.debtorProfile.address.isEmpty {
                                InfoBox(title: "주소", text: .constant("\(newCertificate.debtorProfile.address)"))
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        
                        if newCertificate.paperFormInfo.interestRate != 0 || (newCertificate.paperFormInfo.interestPaymentDate != 0) || !newCertificate.paperFormInfo.specialConditions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("추가사항")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.payritMint)
                                if newCertificate.paperFormInfo.interestRate != 0 {
                                    InfoBox(title: "이자율", text: .constant("\(String(format: "%.2f", newCertificate.paperFormInfo.interestRate))%"), type: .long)
                                }
                                
                                if newCertificate.paperFormInfo.interestPaymentDate != 0 {
                                    InfoBox(title: "이자 지급일", text: .constant("매월 \(newCertificate.paperFormInfo.interestPaymentDate)일"), type: .long)
                                }
                                
                                if !newCertificate.paperFormInfo.specialConditions.isEmpty {
                                    InfoBox(title: "특약사항", text: .constant("\(newCertificate.paperFormInfo.specialConditions)"), type: .long)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .customShadow()
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 16)
                }
                Button {
                    switch saveType.type {
                    case .save:
                        writingStore.saveCertificae(certificate: newCertificate) { result in
                            if result {
                                isShowingKaKaoAlert.toggle()
                            } else {
                                isShowingErrorAlert.toggle()
                            }
                        }
                    case .pix:
                        guard let id = saveType.id else { break }
                        writingStore.pixCertificae(certificate: newCertificate, id: id) { result in
                            if result {
                                isShowingKaKaoAlert.toggle()
                            } else {
                                isShowingErrorAlert.toggle()
                            }
                        }
                    }
                } label: {
                    Text("요청 전송")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: 12))
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
        }
        .dismissOnDrag()
        .navigationTitle("페이릿 내용확인")
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
        .onAppear {
            print(newCertificate.creditorProfile.phoneNumber)
        }
        .primaryAlert(isPresented: $isShowingStopAlert,
                      title: "작성 중단",
                      content: saveType.type == .save ? "지금 작성을 중단하시면\n처음부터 다시 작성해야해요.\n 작성 전 페이지로 돌아갈까요?" : "수정을 종료하시겠습니까?",
                      primaryButtonTitle: "아니오",
                      cancleButtonTitle: "네") {
        } cancleAction: {
            path = .init()
        }
        .primaryAlertNoneTouch(isPresented: $isShowingKaKaoAlert,
                      title: "카카오톡 공유",
                      content: """
                        작성 완료 된 페이릿을
                        카카오톡으로 공유할까요?
                        """,
                      primaryButtonTitle: "네",
                      cancleButtonTitle: "아니오") {
            KakaoShareService().kakaoShare(sender: mypageStore.userCertInfo?.certificationName ?? "") { kakaoLinkType in
                KakaoShareService().openKakaoLink(kakaoLinkType: kakaoLinkType) {
                }
            }
            path = .init()
            tabStore.selectedTab = .home
        } cancleAction: {
            path = .init()
            tabStore.selectedTab = .home
        }
        .primaryAlert(isPresented: $isShowingErrorAlert,
                      title: "에러",
                      content: """
                        페이릿 작성에 실패하였습니다
                        다시 시도하여 주세요
                        """,
                      primaryButtonTitle: nil,
                      cancleButtonTitle: "확인",
                      primaryAction: nil) {
        }
    }
}

#Preview {
    NavigationStack {
        WritingCheckView(saveType: SaveInfo(type: .save, id: 0), writingStore: WritingStore(), path: .constant(NavigationPath()), newCertificate: .constant(CertificateDetail.EmptyCertificate))
            .environment(HomeStore())
            .environment(TabBarStore())
    }
}
