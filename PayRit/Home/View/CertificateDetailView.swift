//
//  CertificateDetailView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.
//

import SwiftUI

struct CertificateDetailView: View {
    @State var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State var certificate: Certificate = Certificate.samepleDocument[0]
    @Binding var index: Int
    @Binding var homeStore: HomeStore
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    if certificate.type == .iBorrowed {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(certificate.recipient)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(certificate.totalAmountFormatter)
                                    .foregroundStyle(Color.payritIntensivePink)
                                Text("원을 빌려주었어요.")
                            }
                        }
                        .font(Font.title03)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(certificate.sender)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(certificate.totalAmountFormatter)
                                    .foregroundStyle(Color.payritMint)
                                Text("원을 빌렸어요.")
                            }
                        }
                        .font(Font.title03)
                    }
                    Spacer()
                }
                
                VStack {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(certificate.tradeDay + " ~ " + certificate.endDay)
                                .font(.custom("SUIT-Medium", size: 12))
                                .foregroundStyle(Color.gray02)
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        Text("남은 금액")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                            .padding(.top, 14)
                        
                        Text(String(certificate.totalAmountFormatter) + "원")
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
                    Spacer().frame(minWidth: 0)
                    // 내보내기 버튼
                    HStack(spacing: 20) {
                        Button {
                            isActionSheetPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "doc")
                                Text("문서로 보내기")
                            }
                            .frame(height: 24)
                            .font(Font.body03)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(Color.gray05)
                            .clipShape(.rect(cornerRadius: 20))
                        }
                        Button {
                            isActionSheetPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "tag")
                                Text("받은 금액 입력하기")
                            }
                            .frame(height: 24)
                            .font(Font.body03)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(Color.payritMint)
                            .clipShape(.rect(cornerRadius: 20))
                        }
                    }
                    .font(Font.body02)
                    .padding(.bottom, 16)
                }
                .frame(height: 240)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                .padding(.top, 24)
                
                HStack {
                    Button {
                        isModalPresented.toggle()
                    } label: {
                        Rectangle()
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
                                .padding(16)
                            }
                            .background()
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                    Spacer().frame(width: 14)
                    NavigationLink {
                        CertificateMemoView(index: $index, homeStore: $homeStore)
                            .customBackbutton()
                    } label: {
                        VStack(spacing: 0) {
                            Rectangle()
                                .foregroundStyle(Color.white)
                                .frame(height: 105)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("개인 메모")
                                            .font(Font.body01)
                                            .foregroundStyle(.black)
                                        Text("최근 날짜의 메모가 요약으로 보여집니다.")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray05)
                                        .multilineTextAlignment(.leading)
                                        Spacer()
                                    }
                                        .padding(.top, 16)
                                        .padding(.leading, 16)
                                    , alignment: .leading
                                )
                            Rectangle()
                                .foregroundStyle(Color.gray08)
                                .frame(height: 50)
                                .overlay(
                                    Text("총 \(certificate.memo.count)개의 메모")
                                        .font(Font.caption02)
                                        .foregroundStyle(Color.gray02)
                                        .padding(.leading, 16)
                                    , alignment: .leading
                                )
                        }
                        .background()
                        .clipShape(.rect(cornerRadius: 12))
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                    }
                }
                .padding(.top, 14)
                
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
            .padding(.top, 20)
        }
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
        .onAppear {
            certificate = homeStore.certificates[index]
        }
    }
}

#Preview {
    NavigationStack {
        CertificateDetailView(index: .constant(1), homeStore: .constant(HomeStore()))
    }
}
