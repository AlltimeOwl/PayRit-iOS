//
//  CertificateDetailView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.
//

import SwiftUI
import UIKit
import MessageUI

struct CertificateDetailView: View {
    @State private var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State private var isShowingMailView: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @Binding var homeStore: HomeStore
    let index: Int
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    if homeStore.certificates[index].type == .iBorrowed {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(homeStore.certificates[index].recipient)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(homeStore.certificates[index].totalAmountFormatter)
                                    .foregroundStyle(Color.payritIntensivePink)
                                Text("원을 빌렸어요.")
                            }
                        }
                        .font(Font.title03)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(homeStore.certificates[index].sender)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(homeStore.certificates[index].totalAmountFormatter)
                                    .foregroundStyle(Color.payritMint)
                                Text("원을 빌려주었어요.")
                            }
                        }
                        .font(Font.title03)
                    }
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("원금상환일 \(homeStore.certificates[index].redemptionDate)")
                                .font(Font.caption02)
                                .foregroundStyle(Color.gray02)
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        Text("남은 금액")
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
                            .padding(.top, 14)
                        
                        Text(String(homeStore.certificates[index].totalAmountFormatter) + "원")
                            .font(Font.title01)
                            .padding(.top, 2)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 6) {
                            HStack { Spacer() }
                            if homeStore.certificates[index].dDay >= 0 {
                                Text("D - \(homeStore.certificates[index].dDay)")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray02)
                            } else {
                                Text("D + \(-homeStore.certificates[index].dDay)")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray02)
                            }
                            ProgressView(value: 50, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: homeStore.certificates[index].type == .iBorrowed ? Color.payritIntensivePink : Color.payritMint))
                            Text(homeStore.certificates[index].state.rawValue + "(50%)")
                                .font(Font.caption02)
                                .foregroundStyle(Color.gray04)
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
                    .background(homeStore.certificates[index].type == .iBorrowed ? Color.payritIntensiveLightPink : Color.payritLightMint)
                    .clipShape(.rect(cornerRadius: 12))
                    Spacer().frame(minWidth: 16)
                    HStack {
                        Text("받은 날짜")
                            .frame(width: UIScreen.screenWidth * 0.4)
                        Text("상환 내역")
                            .frame(width: UIScreen.screenWidth * 0.4)
                    }
                    .font(Font.title06)
                    
                    ForEach(homeStore.certificates[index].deductedHistory) { deducted in
                        HStack {
                            Text(deducted.date)
                                .frame(width: UIScreen.screenWidth * 0.4)
                            Text("\(deducted.money)원")
                                .frame(width: UIScreen.screenWidth * 0.4)
                        }
                        .font(Font.body02)
                        .padding(.vertical, 6)
                    }
                    
                    // 내보내기 버튼
                    HStack {
                        Button {
                            isActionSheetPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "doc")
                                Text("PDF·메일")
                            }
                            .frame(height: 24)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                Capsule()
                                    .fill(Color.gray05)
                            )
                        }
                        Button {
                            isActionSheetPresented.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "paperplane")
                                Text("알림 전송")
                            }
                            .frame(height: 24)
                            .foregroundStyle(.white)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                Capsule()
                                    .fill(Color.payritIntensivePink)
                            )
                        }
                        if homeStore.certificates[index].type == .iLentYou {
                            NavigationLink {
                                CertificateDeductibleView(homeStore: $homeStore, index: index)
                                    .customBackbutton()
                            } label: {
                                HStack {
                                    Image(systemName: "tag")
                                    Text("금액 입력하기")
                                }
                                .frame(height: 24)
                                .foregroundStyle(.white)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(
                                    Capsule()
                                        .fill(Color.payritMint)
                                )
                            }
                        }
                    }
                    .font(Font.body03)
                    .padding(.vertical, 16)
                }
                .frame(height: 370)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                .padding(.top, 24)
                
                HStack {
                    Button {
                        isModalPresented.toggle()
                    } label: {
                        Rectangle()
                            .foregroundStyle(homeStore.certificates[index].type == .iBorrowed ? Color.payritIntensiveLightPink : Color.payritLightMint)
                            .frame(width: 130, height: 155)
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            .overlay {
                                VStack(alignment: .leading) {
                                    Text("""
                                         차용증
                                         보기
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
                        CertificateMemoView(homeStore: $homeStore, index: index)
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
                                    Text("총 \(homeStore.certificates[index].memo.count)개의 메모")
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
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
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
                            .font(Font.body04)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(homeStore.certificates[index].sender)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].senderPhoneNumber)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].senderAdress)")
                                }
                            }
                            .font(Font.body01)
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
                            .font(Font.body03)
                            .foregroundStyle(Color.gray04)
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
                            .font(Font.body04)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("\(homeStore.certificates[index].recipient)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].recipientPhoneNumber)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].recipientAdress)")
                                }
                            }
                            .font(Font.body01)
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
        .CertificateDetailImage(isPresented: $isModalPresented, isButtonShowing: .constant(true))
        .confirmationDialog("", isPresented: $isActionSheetPresented, titleVisibility: .hidden) {
            Button("PDF 다운") {
            }
            Button("이메일 전송") {
                if MFMailComposeViewController.canSendMail() {
                        self.isShowingMailView.toggle()
                } else {
                    print("메일을 보낼수 없는 기기입니다.")
                }
                if result != nil {
                    print("Result: \(String(describing: result))")
                }
            }
            Button("취소", role: .cancel) {
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: self.$result) { composer in
                composer.setSubject("페이릿 차용증 \(homeStore.todayString())")
                composer.setToRecipients([""])
                composer.setMessageBody("", isHTML: false)
                
                if let imageData = UIImage(named: "homeBoxImage")?.jpegData(compressionQuality: 1.0) {
                    composer.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "\(Date()).jpg")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CertificateDetailView(homeStore: .constant(HomeStore()), index: 0)
    }
}
