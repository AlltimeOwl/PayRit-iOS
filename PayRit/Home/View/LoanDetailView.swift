//
//  LoanDetailView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.
//

import SwiftUI

struct LoanDetailView: View {
    @Binding var certificate: Certificate
    @State var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("""
                     \(certificate.recipient)님께
                     빌려주었어요
                     """)
                    .font(Font.title03)
                    .lineSpacing(4)
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text(certificate.tradeDay.replacingOccurrences(of: "-", with: ".") + " ~ " + certificate.endDay.replacingOccurrences(of: "-", with: "."))
                            .font(.custom("SUIT-Medium", size: 12))
                            .foregroundStyle(Color.gray02)
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    Text("남은 금액")
                        .font(Font.body03)
                        .foregroundStyle(Color.gray04)
                        .padding(.top, 14)
                    
                    Text(String(certificate.totalMoneyFormatter) + "원")
                        .font(.custom("SUIT-Bold", size: 28))
                        .padding(.top, 2)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 6) {
                        HStack { Spacer() }
                        if certificate.dDay >= 0 {
                            Text("D - \(certificate.dDay)")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray02)
                        } else {
                            Text("D + \(-certificate.dDay)")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray02)
                        }
                        ProgressView(value: 50, total: 100)
                            .progressViewStyle(LinearProgressViewStyle(tint: Color.payritMint))
                        Text(certificate.state.rawValue + "(50%)")
                            .font(.custom("SUIT-Medium", size: 10))
                    }
                    .padding(.bottom, 16)
                }
                .padding(.horizontal, 16)
                .frame(height: 170)
                .frame(maxWidth: .infinity)
                .background(Color.payritLightMint)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                .padding(.top, 24)
                
                // 내보내기 버튼
                HStack(spacing: 20) {
                    Button {
                        isActionSheetPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "doc")
                            Text("문서로 보내기")
                        }
                        .frame(height: 16)
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.gray05)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    Button {
                        isActionSheetPresented.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "doc")
                            Text("받은 금액 입력하기")
                        }
                        .frame(height: 16)
                        .font(.system(size: 12))
                        .foregroundStyle(.white)
                        .bold()
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color.payritMint)
                        .clipShape(.rect(cornerRadius: 20))
                    }
                    .frame(height: 30)
                }
                .padding(.top, 20)
                .font(.system(size: 12))
                .bold()
                
                HStack {
                    Button {
                        isModalPresented.toggle()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.payritLightMint)
                            .frame(width: 130, height: 155)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("""
                                         차용증
                                         미리보기
                                         """)
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.leading)
                                    .font(Font.body01)
                                    .foregroundStyle(.black)
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Image(systemName: "arrow.down.backward.and.arrow.up.forward")
                                            .font(.system(size: 20))
                                            .foregroundStyle(Color.gray04)
                                    }
                                }
                                .padding(14)
                            }
                        
                    }
                    NavigationLink {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(Color.white)
                            .frame(height: 155)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading) {
                        Text("빌려준 사람")
                            .foregroundStyle(Color.gray04)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        HStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("이름")
                                }
                                HStack {
                                    Text("연락처")
                                }
                                HStack {
                                    Text("주소")
                                }
                            }
                            .bold()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(certificate.sender)")
                                }
                                HStack {
                                    Text("\(certificate.senderPhoneNumber)")
                                }
                                HStack {
                                    Text("\(certificate.senderAdress)")
                                }
                            }
                            Spacer()
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    
                    // 빌린 사람 정보
                    VStack(alignment: .leading) {
                        Text("빌린 사람")
                            .foregroundStyle(Color.gray04)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        HStack(alignment: .center, spacing: 20) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("이름")
                                }
                                HStack {
                                    Text("연락처")
                                }
                                HStack {
                                    Text("주소")
                                }
                            }
                            .bold()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(certificate.recipient)")
                                }
                                HStack {
                                    Text("\(certificate.recipientPhoneNumber)")
                                }
                                HStack {
                                    Text("\(certificate.recipientAdress)")
                                }
                            }
                            Spacer()
                        }
                        .padding(20)
                        .background(Color.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                }
                .padding(.top, 20)
                .font(.system(size: 18))
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 20)
        .scrollIndicators(.hidden)
        .navigationTitle("페이릿 상세 페이지")
        .navigationBarTitleDisplayMode(.inline)
        .LoanDetailImage(isPresented: $isModalPresented, isButtonShowing: .constant(true))
        .confirmationDialog("", isPresented: $isActionSheetPresented, titleVisibility: .hidden) {
            Button("PDF 다운") {
            }
            Button("이메일 전송") {
            }
            Button("취소", role: .cancel) {
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoanDetailView(certificate: .constant(Certificate.samepleDocument[0]))
    }
}
