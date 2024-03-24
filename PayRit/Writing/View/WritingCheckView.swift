//
//  WritingCheckView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct WritingCheckView: View {
    let writingStore = WritingStore()
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingKaKaoAlert: Bool = false
    @State private var isShowingDoneAlert: Bool = false
    @Binding var path: NavigationPath
    @Binding var newCertificate: CertificateDetail
    @Environment(HomeStore.self) var homeStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("거래내역")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("금액")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(newCertificate.primeAmountFomatter)원")
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
                                        Text("\(newCertificate.repaymentEndDate)")
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
                        }
                        
                        if newCertificate.interestRate != 0 || (newCertificate.interestPaymentDate != 0) || (newCertificate.specialConditions != nil) {
                            VStack(alignment: .leading) {
                                Text("추가사항")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                VStack(alignment: .leading, spacing: 12) {
                                    if newCertificate.interestRate != 0 {
                                        HStack {
                                            Text("이자율")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("\(String(format: "%.2f", newCertificate.interestRate))%")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    
                                    if newCertificate.interestPaymentDate != 0 {
                                        HStack {
                                            Text("이자 지급일")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("매월 \(newCertificate.interestPaymentDate)일")
                                                    .font(Font.body01)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                    
                                    if let specialConditions = newCertificate.specialConditions {
                                        HStack {
                                            Text("특이사항")
                                                .font(Font.body04)
                                            Spacer()
                                            HStack {
                                                Text("\(specialConditions)")
                                                    .font(Font.body01)
                                                    .multilineTextAlignment(.leading)
                                                Spacer()
                                            }
                                            .frame(width: 220)
                                        }
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "E5FDFC"))
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("빌려준 사람")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("이름")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(newCertificate.creditorName)")
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
                                        Text("\(newCertificate.creditorPhoneNumber.onlyPhoneNumber())")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !newCertificate.creditorAddress.isEmpty {
                                    HStack {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(newCertificate.creditorAddress)")
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
                        }
                        
                        VStack(alignment: .leading) {
                            Text("빌린 사람")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("이름")
                                        .font(Font.body04)
                                    Spacer()
                                    HStack {
                                        Text("\(newCertificate.debtorName)")
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
                                        Text("\(newCertificate.debtorPhoneNumber.onlyPhoneNumber())")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .frame(width: 220)
                                }
                                if !newCertificate.debtorAddress.isEmpty {
                                    HStack {
                                        Text("주소")
                                            .font(Font.body04)
                                        Spacer()
                                        HStack {
                                            Text("\(newCertificate.debtorAddress)")
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
                        }
                    }
                    .padding(.vertical, 30)
                    .padding(.horizontal, 16)
                }
                Button {
                    isShowingKaKaoAlert.toggle()
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
        .primaryAlert(isPresented: $isShowingKaKaoAlert,
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
        .primaryAlert(isPresented: $isShowingDoneAlert,
                      title: "카카오톡 요청 완료",
                      content: """
                        상대방에게 카카오톡으로 요청이
                        완료되었습니다.
                        """,
                      primaryButtonTitle: nil,
                      cancleButtonTitle: "확인",
                      primaryAction: nil) {
            writingStore.saveCertificae(certificate: newCertificate)
            path = .init()
        }
    }
}

#Preview {
    NavigationStack {
        WritingCheckView(path: .constant(NavigationPath()), newCertificate: .constant(CertificateDetail.testCertofocateDetail))
            .environment(HomeStore())
    }
}
