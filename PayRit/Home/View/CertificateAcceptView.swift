//
//  CertificateAcceptView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateAcceptView: View {
    let paperId: Int
    let certificateStep: CertificateStep
    @State private var checkBox: Bool = false
    @State private var authResult: Bool = false
    @State private var paymentResult: Bool = false
    @State private var isShowingAuthAlert: Bool = false
    @State private var isShowingPaymentAlert: Bool = false
    @Environment(HomeStore.self) var homeStore: HomeStore
    @EnvironmentObject var iamportStore: IamportStore
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("거래내역")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                HStack {
                                    Text("금액")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.paperFormInfo.primeAmountFomatter)원")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                HStack {
                                    Text("원금 상환일")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.paperFormInfo.repaymentEndDate.replacingOccurrences(of: "-", with: "."))")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                        
                            VStack(alignment: .leading, spacing: 12) {
                                Text("빌려준 사람")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                HStack {
                                    Text("이름")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.creditorProfile.name)")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                HStack {
                                    Text("연락처")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.creditorProfile.phoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !homeStore.certificateDetail.creditorProfile.address.isEmpty {
                                    HStack(alignment: .top) {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(homeStore.certificateDetail.creditorProfile.address)")
                                                .fixedSize(horizontal: false, vertical: true)
                                                .font(Font.body01)
                                            Spacer()
                                        }
                                        .frame(width: 220)
                                    }
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                        
                            VStack(alignment: .leading, spacing: 12) {
                                Text("빌린 사람")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                HStack {
                                    Text("이름")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.debtorProfile.name)")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                HStack {
                                    Text("연락처")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(homeStore.certificateDetail.debtorProfile.phoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !homeStore.certificateDetail.debtorProfile.address.isEmpty {
                                    HStack(alignment: .top) {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(homeStore.certificateDetail.debtorProfile.address)")
                                                .fixedSize(horizontal: false, vertical: true)
                                                .font(Font.body01)
                                            Spacer()
                                        }
                                        .frame(width: 220)
                                    }
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                        
                        if homeStore.certificateDetail.paperFormInfo.interestRate != 0 || homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 || homeStore.certificateDetail.paperFormInfo.specialConditions != nil {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("추가사항")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray04)
                                    if homeStore.certificateDetail.paperFormInfo.interestRate != 0 {
                                        HStack {
                                            Text("이자율")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("\(String(format: "%.2f", homeStore.certificateDetail.paperFormInfo.interestRate))%")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    if homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 {
                                        HStack {
                                            Text("이자 지급일")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("매월 \(homeStore.certificateDetail.paperFormInfo.interestPaymentDate)일")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    if let specialConditions = homeStore.certificateDetail.paperFormInfo.specialConditions {
                                        HStack {
                                            Text("특이사항")
                                                .font(Font.body04)
                                            Spacer()
                                            Text("\(specialConditions)")
                                                .font(Font.body01)
                                                .frame(width: 220)
                                            Spacer()
                                        }
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "E5FDFC"))
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                        }
                            
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
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                }
                VStack {
                    if certificateStep == .waitingApproval {
                        Button {
                            isShowingAuthAlert.toggle()
                        } label: {
                            Text("수락 하기")
                                .font(Font.title04)
                                .foregroundStyle(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(checkBox ? Color.payritMint : Color.gray07)
                                .clipShape(.rect(cornerRadius: 12))
                        }
                        .disabled(!checkBox)
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
        .dismissOnDrag()
        .navigationTitle("페이릿 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await homeStore.loadDetail(id: paperId)
            }
        }
        .primaryAlert(isPresented: $isShowingAuthAlert, title: "본인인증", content: "페이릿 수락을 위해 본인인증을 진행합니다.", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isCert = true
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingPaymentAlert, title: "결제", content: "결제 후 최종 작성됩니다.\n 결제하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            iamportStore.isPayment = true
        } cancleAction: {
        }
        .onChange(of: iamportStore.acceptAuthResult) {
            if iamportStore.acceptAuthResult {
                homeStore.acceptCertificate(paperId: paperId)
            }
        }
        .onChange(of: iamportStore.paymentResult) {
            if iamportStore.paymentResult {
                homeStore.savePaymentHistory(paperId: paperId, amount: iamportStore.amount, impUid: iamportStore.impUid, merchantUid: iamportStore.merchantUid)
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        CertificateAcceptView(paperId: 0, certificateStep: .progress)
            .environment(HomeStore())
    }
}
