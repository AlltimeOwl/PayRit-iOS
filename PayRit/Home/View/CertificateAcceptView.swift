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
    @Environment(HomeStore.self) var homeStore: HomeStore
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
                                        Text("\(homeStore.certificateDetail.primeAmountFomatter)원")
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
                                        Text("\(homeStore.certificateDetail.repaymentEndDate.replacingOccurrences(of: "-", with: "."))")
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
                                        Text("\(homeStore.certificateDetail.creditorName)")
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
                                        Text("\(homeStore.certificateDetail.creditorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !homeStore.certificateDetail.creditorAddress.isEmpty {
                                    HStack(alignment: .top) {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(homeStore.certificateDetail.creditorAddress)")
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
                                        Text("\(homeStore.certificateDetail.debtorName)")
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
                                        Text("\(homeStore.certificateDetail.debtorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !homeStore.certificateDetail.debtorAddress.isEmpty {
                                    HStack(alignment: .top) {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(homeStore.certificateDetail.debtorAddress)")
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
                        
                        if homeStore.certificateDetail.interestRate != 0 || homeStore.certificateDetail.interestPaymentDate != 0 || homeStore.certificateDetail.specialConditions != nil {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("추가사항")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray04)
                                    if homeStore.certificateDetail.interestRate != 0 {
                                        HStack {
                                            Text("이자율")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("\(String(format: "%.2f", homeStore.certificateDetail.interestRate))%")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    if homeStore.certificateDetail.interestPaymentDate != 0 {
                                        HStack {
                                            Text("이자 지급일")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("매월 \(homeStore.certificateDetail.interestPaymentDate)일")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    if let specialConditions = homeStore.certificateDetail.specialConditions {
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
                            homeStore.acceptCertificate(paperId: homeStore.certificateDetail.paperId)
                            dismiss()
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
                            homeStore.acceptCertificate(paperId: homeStore.certificateDetail.paperId)
                            dismiss()
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
        }
        .dismissOnDrag()
        .navigationTitle("페이릿 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await homeStore.loadDetail(id: paperId)
            }
        }
        .toolbar {
        }
    }
}

#Preview {
    NavigationStack {
        CertificateAcceptView(paperId: 0, certificateStep: .progress)
            .environment(HomeStore())
    }
}
