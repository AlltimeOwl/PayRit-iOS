//
//  CertificateAcceptView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateAcceptView: View {
    let index: Int
    @State private var checkBox: Bool = false
    @Environment(HomeStore.self) var homeStore: HomeStore
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack(spacing: 0) {
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
                                Text("\(homeStore.certificates[index].totalAmountFormatter)원")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("원금 상환일")
                                    .font(Font.body04)
                                Spacer().frame(width: 30)
                                Text("\(homeStore.certificates[index].repaymentEndDate)")
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
                                Text("\(homeStore.certificates[index].totalAmount - homeStore.certificates[index].money)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("이자 지급일")
                                    .font(Font.body04)
                                Spacer().frame(width: 30)
                                Text("매월 \(homeStore.certificates[index].interestRateDay ?? "")일")
                                    .foregroundStyle(!homeStore.certificates[index].repaymentEndDate.isEmpty ? .black : .clear)
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("특이사항")
                                    .font(Font.body04)
                                Spacer().frame(width: 70)
                                Text("\(homeStore.certificates[index].etc ?? "")")
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
                                Text("\(homeStore.certificates[index].creditorName)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("연락처")
                                    .font(Font.body04)
                                Spacer().frame(width: 20)
                                Text("\(homeStore.certificates[index].creditorPhoneNumber)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("주소")
                                    .font(Font.body04)
                                Spacer().frame(width: 33)
                                Text("\(homeStore.certificates[index].creditorAddress)")
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
                                Text("\(homeStore.certificates[index].debtorName)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("연락처")
                                    .font(Font.body04)
                                Spacer().frame(width: 20)
                                Text("\(homeStore.certificates[index].debtorPhoneNumber)")
                                    .font(Font.body01)
                                Spacer()
                            }
                            HStack {
                                Text("주소")
                                    .font(Font.body04)
                                Spacer().frame(width: 33)
                                Text("\(homeStore.certificates[index].debtorAddress)")
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
                homeStore.certificates[index].state = .waitingPayment
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
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
        }
        .navigationTitle("페이릿 내용 확인")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
        }
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
        CertificateAcceptView(index: 0)
            .environment(HomeStore())
    }
}
