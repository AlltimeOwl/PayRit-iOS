//
//  WritingCheckView.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//

import SwiftUI

struct WritingCheckView: View {
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingKaKaoAlert: Bool = false
    @State private var isShowingDoneAlert: Bool = false
    @Binding var path: NavigationPath
    @Binding var newCertificate: Certificate
    var body: some View {
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
                            Text("\(newCertificate.totalAmountFormatter)원")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("원금 상환일")
                                .font(Font.body04)
                            Spacer().frame(width: 30)
                            Text("\(newCertificate.redemptionDate)")
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
                            Text("\(newCertificate.totalAmount - newCertificate.totalMoney)")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("이자 지급일")
                                .font(Font.body04)
                            Spacer().frame(width: 30)
                            Text("매월 \(newCertificate.interestRateDay ?? "")일")
                                .foregroundStyle(!newCertificate.redemptionDate.isEmpty ? .black : .clear)
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("특이사항")
                                .font(Font.body04)
                            Spacer().frame(width: 70)
                            Text("\(newCertificate.etc ?? "")")
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
                            Text("\(newCertificate.sender)")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("연락처")
                                .font(Font.body04)
                            Spacer().frame(width: 20)
                            Text("\(newCertificate.senderPhoneNumber)")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("주소")
                                .font(Font.body04)
                            Spacer().frame(width: 33)
                            Text("\(newCertificate.senderAdress)")
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
                            Text("\(newCertificate.recipient)")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("연락처")
                                .font(Font.body04)
                            Spacer().frame(width: 20)
                            Text("\(newCertificate.recipientPhoneNumber)")
                                .font(Font.body01)
                            Spacer()
                        }
                        HStack {
                            Text("주소")
                                .font(Font.body04)
                            Spacer().frame(width: 33)
                            Text("\(newCertificate.recipientAdress)")
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
                
                Spacer()
                
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
}

#Preview {
    NavigationStack {
        WritingCheckView(path: .constant(NavigationPath()), newCertificate: .constant(Certificate.samepleDocument[0]))
    }
}
