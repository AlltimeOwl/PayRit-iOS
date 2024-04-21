//
//  CertificateAcceptView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateAcceptView: View {
    let paperId: Int
    let isWriter: Bool?
    let certificateStep: CertificateStep
    @State var pixAlertContent: String = ""
    @State private var isLoading: Bool = true
    @State private var checkBox: Bool = false
    @State private var authResult: Bool = false
    @State private var paymentResult: Bool = false
    @State private var isShowingPixSuccessAlert: Bool = false
    @State private var isShowingPixfailAlert: Bool = false
    @State private var isShowingAuthAlert: Bool = false
    @State private var isShowingPaymentAlert: Bool = false
    @State private var isShowingPixAlert: Bool = false
    @State private var isShowingRefuseAlert: Bool = false
    @State private var isShowingRefuseDoneAlert: Bool = false
    @State private var isShowingWritingView: Bool = false
    @Binding var path: NavigationPath
    @Environment(HomeStore.self) var homeStore
    @Environment(MyPageStore.self) var mypageStore
    @EnvironmentObject var iamportStore: IamportStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        if let modityText = homeStore.certificateDetail.modifyRequest {
                            if modityText != "null" {
                                VStack(alignment: .leading, spacing: 18) {
                                    Text("수정요청 메세지")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray05)
                                    HStack {
                                        Text(modityText)
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "E5FDFC"))
                                .clipShape(.rect(cornerRadius: 12))
                                .customShadow()
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("거래내역")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            InfoBox(title: "금액(원금)", text: .constant("\(homeStore.certificateDetail.paperFormInfo.primeAmountFomatter)원"), type: .long)
                            InfoBox(title: "원금 상환일", text: .constant("\(homeStore.certificateDetail.paperFormInfo.repaymentEndDate.replacingOccurrences(of: "-", with: "."))"), type: .long)
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
                            
                            InfoBox(title: "이름", text: .constant("\(homeStore.certificateDetail.creditorProfile.name)"))
                            InfoBox(title: "연락처", text: .constant("\(homeStore.certificateDetail.creditorProfile.phoneNumber.phoneNumberMiddleCase())"))
                            
                            if !homeStore.certificateDetail.creditorProfile.address.isEmpty {
                                InfoBox(title: "주소", text: .constant("\(homeStore.certificateDetail.creditorProfile.address)"))
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
                            InfoBox(title: "이름", text: .constant("\(homeStore.certificateDetail.debtorProfile.name)"))
                            InfoBox(title: "연락처", text: .constant("\(homeStore.certificateDetail.debtorProfile.phoneNumber.phoneNumberMiddleCase())"))
                            
                            if !homeStore.certificateDetail.debtorProfile.address.isEmpty {
                                InfoBox(title: "주소", text: .constant("\(homeStore.certificateDetail.debtorProfile.address)"))
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        
                        if homeStore.certificateDetail.paperFormInfo.interestRate != 0 || homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 || !homeStore.certificateDetail.paperFormInfo.specialConditions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("추가사항")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.payritMint)
                                if homeStore.certificateDetail.paperFormInfo.interestRate != 0 {
                                    InfoBox(title: "이자율", text: .constant("\(String(format: "%.2f", homeStore.certificateDetail.paperFormInfo.interestRate))%"), type: .long)
                                }
                                if homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 {
                                    InfoBox(title: "이자 지급일", text: .constant("매월 \(homeStore.certificateDetail.paperFormInfo.interestPaymentDate)일"), type: .long)
                                }
                                if !homeStore.certificateDetail.paperFormInfo.specialConditions.isEmpty {
                                    InfoBox(title: "특약사항", text: .constant("\(homeStore.certificateDetail.paperFormInfo.specialConditions)"), type: .long)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .customShadow()
                        }
                        if certificateStep != .modifying {
                            Button {
                                checkBox.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: checkBox ? "checkmark.square.fill" : "checkmark.square" )
                                        .foregroundStyle(Color(hex: "37D9BC"))
                                    Text("위 정보가 정확한지 확인 했어요 (필수)")
                                        .font(Font.caption02)
                                        .foregroundStyle(Color(hex: "5C5C5C"))
                                }
                            }
                            .padding(.bottom, 40)
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 16)
                }
                .onAppear {
                    UITableView.appearance().refreshControl = nil
                }
                VStack {
                    if certificateStep == .waitingApproval {
                        if let isWriter = isWriter {
                            if isWriter {
                                Button {
                                    KakaoShareService().kakaoShare(sender: mypageStore.userCertInfo?.certificationName ?? "") { kakaoLinkType in
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
                            } else {
                                if !checkBox {
                                    Button {
                                        isShowingPixAlert.toggle()
                                    } label: {
                                        Text("수정 요청하기")
                                            .font(Font.title04)
                                            .foregroundStyle(.white)
                                            .frame(height: 50)
                                            .frame(maxWidth: .infinity)
                                            .background(Color.payritMint)
                                            .clipShape(.rect(cornerRadius: 12))
                                    }
                                } else {
                                    HStack {
                                        Button {
                                            isShowingRefuseAlert.toggle()
                                        } label: {
                                            Text("거절")
                                                .font(Font.title04)
                                                .foregroundStyle(.white)
                                                .frame(height: 50)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray07)
                                                .clipShape(.rect(cornerRadius: 12))
                                        }
                                        .frame(width: 90)
                                        
                                        Button {
                                            isShowingAuthAlert.toggle()
                                        } label: {
                                            Text("수락하기")
                                                .font(Font.title04)
                                                .foregroundStyle(.white)
                                                .frame(height: 50)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.payritMint)
                                                .clipShape(.rect(cornerRadius: 12))
                                        }
                                    }
                                }
                            }
                        }
                    } else if certificateStep == .waitingPayment {
                        Button {
                            isShowingPaymentAlert.toggle()
                        } label: {
                            Text("결제 하기")
                                .font(Font.title04)
                                .foregroundStyle(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(checkBox ? Color.payritMint : Color.gray07)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .disabled(!checkBox)
                    } else if certificateStep == .modifying {
                        Button {
                            isShowingWritingView.toggle()
                        } label: {
                            Text("수정 하기")
                                .font(Font.title04)
                                .foregroundStyle(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(Color.payritMint)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                    }
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
            if iamportStore.isCert {
                IMPCertificationView(certType: .constant(.once))
                    .onDisappear {
                        iamportStore.clearButton()
                    }
            }
            if iamportStore.isPayment {
                IMPPaymentView(paperId: paperId)
                    .onDisappear {
                        iamportStore.clearButton()
                    }
            }
        }
        .redacted(reason: isLoading ? .placeholder : [])
        .dismissOnDrag()
        .navigationTitle("페이릿 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .primaryAlert(isPresented: $isShowingAuthAlert, title: "본인인증", content: "페이릿 수락을 위해 본인인증을 진행합니다.", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isCert = true
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingPaymentAlert, title: "결제", content: "결제 후 최종 작성됩니다.\n 결제하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isPayment = true
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingPixSuccessAlert, title: "수정 요청 성공", content: "수정 요청에 성공하였습니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
            self.presentationMode.wrappedValue.dismiss()
        }
        .primaryAlert(isPresented: $isShowingPixfailAlert, title: "수정 요청 실패", content: "수정 요청에 실패하였습니다.\n다시 시도해 주세요.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingRefuseAlert, title: "거절", content: "페이릿을 거절하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            homeStore.certificateRefuse(id: paperId) { result in
                if result {
                    isShowingRefuseDoneAlert.toggle()
                }
            }
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingRefuseDoneAlert, title: "거절", content: "거절이 완료되었습니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
            Task {
                await homeStore.loadCertificates()
            }
            self.presentationMode.wrappedValue.dismiss()
        }
        .pixAlert(isPresented: $isShowingPixAlert, content: $pixAlertContent, title: "수정사항 요청", primaryButtonTitle: "보내기", cancleButtonTitle: "취소", primaryAction: {
            homeStore.certificatePixRequest(paperId: paperId, contents: pixAlertContent) { result in
                if result {
                    isShowingPixSuccessAlert.toggle()
                } else {
                    isShowingPixfailAlert.toggle()
                }
            }
        }, cancleAction: {
            
        })
        .onChange(of: iamportStore.acceptAuthResult) {
            if iamportStore.acceptAuthResult {
                homeStore.acceptCertificate(paperId: paperId)
            }
        }
        .onChange(of: iamportStore.paymentResult) {
            if iamportStore.paymentResult {
                homeStore.savePaymentHistory(paperId: paperId, amount: iamportStore.amount, impUid: iamportStore.impUid, merchantUid: iamportStore.merchantUid)
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear {
            self.isLoading = true
            Task {
                await homeStore.loadDetail(id: paperId)
                withAnimation {
                    self.isLoading = false
                }
            }
        }
        .navigationDestination(isPresented: $isShowingWritingView) {
            PaperPixView(certificateType: homeStore.certificateDetail.memberRole, newCertificate: homeStore.certificateDetail, path: $path)
                .customBackbutton()
        }
    }
}

#Preview {
    NavigationStack {
        CertificateAcceptView(paperId: 0, isWriter: true, certificateStep: .progress, path: .constant(NavigationPath()))
            .environment(HomeStore())
            .environmentObject(IamportStore())
    }
}
