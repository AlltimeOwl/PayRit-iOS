//
//  CertificateAcceptView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateAcceptView: View {
    @State private var checkBox: Bool = false
    @Binding var certificate: Certificate
    var body: some View {
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
                                Spacer().frame(width: 70)
                                Text("\(certificate.totalAmountFormatter)원")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("원금 상환일")
                                    .font(Font.body04)
                                Spacer().frame(width: 30)
                                Text("\(certificate.redemptionDate)")
                                    .font(Font.body01)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("추가사항")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("이자")
                                    .font(Font.body04)
                                Spacer().frame(width: 70)
                                Text("\(certificate.totalAmount - certificate.money)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("이자 지급일")
                                    .font(Font.body04)
                                Spacer().frame(width: 30)
                                Text("매월 \(certificate.interestRateDay ?? "")일")
                                    .foregroundStyle(!certificate.redemptionDate.isEmpty ? .black : .clear)
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("특이사항")
                                    .font(Font.body04)
                                Spacer().frame(width: 70)
                                Text("\(certificate.etc ?? "")")
                                    .font(Font.body01)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(Color(hex: "E5FDFC"))
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("빌려준 사람")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("이름")
                                    .font(Font.body04)
                                Spacer().frame(width: 33)
                                Text("\(certificate.sender)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("연락처")
                                    .font(Font.body04)
                                Spacer().frame(width: 20)
                                Text("\(certificate.senderPhoneNumber)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("주소")
                                    .font(Font.body04)
                                Spacer().frame(width: 33)
                                Text("\(certificate.senderAdress)")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.body01)
                                Spacer()
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
                                Spacer().frame(width: 33)
                                Text("\(certificate.recipient)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("연락처")
                                    .font(Font.body04)
                                Spacer().frame(width: 20)
                                Text("\(certificate.recipientPhoneNumber)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("주소")
                                    .font(Font.body04)
                                Spacer().frame(width: 33)
                                Text("\(certificate.recipientAdress)")
                                    .fixedSize(horizontal: false, vertical: true)
                                    .font(Font.body01)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    HStack {
                        Button {
                            checkBox.toggle()
                        } label: {
                            Image(systemName: checkBox ? "checkmark.square.fill" : "checkmark.square" )
                                .foregroundStyle(Color(hex: "37D9BC"))
                        }
                        Text("위 정보가 정확한지 확인 했어요 (필수)")
                            .font(Font.caption02)
                            .foregroundStyle(Color(hex: "5C5C5C"))
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top, 30)
                .padding(.horizontal, 16)
            }
            Button {
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
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .navigationTitle("페이릿 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
//            ToolbarItem {
//                Button {
//                } label: {
//                    Image(systemName: "xmark")
//                        .foregroundStyle(.black)
//                }
//            }
        }
    }
}

#Preview {
    NavigationStack {
        CertificateAcceptView(certificate: .constant(Certificate.samepleDocument[0]))
    }
}
