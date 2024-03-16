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
    @State private var pdfURL: URL?
    @State private var isModalPresented: Bool = false
    @State private var isActionSheetPresented: Bool = false
    @State private var isShowingPDFView: Bool = false
    @State private var isShowingMailView: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @Environment(HomeStore.self) var homeStore
    let index: Int
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    if homeStore.certificates[index].cardColor == .payritMint {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(homeStore.certificates[index].debtorName)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(homeStore.certificates[index].totalAmountFormatter)
                                    .foregroundStyle(Color.payritMint)
                                Text("원을 빌려주었어요.")
                            }
                        }
                        .font(Font.title03)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(homeStore.certificates[index].creditorName)님께")
                            HStack(spacing: 0) {
                                Text("총 ")
                                Text(homeStore.certificates[index].totalAmountFormatter)
                                    .foregroundStyle(Color.payritIntensivePink)
                                Text("원을 빌렸어요.")
                            }
                        }
                        .font(Font.title03)
                    }
                    Spacer()
                }
                
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text("원금상환일 \(homeStore.certificates[index].repaymentEndDate)")
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
                            ProgressView(value: homeStore.certificates[index].state == .progress ? homeStore.certificates[index].progressValue : 0, total: 100)
                                .progressViewStyle(LinearProgressViewStyle(tint: homeStore.certificates[index].cardColor == Color.payritMint ? Color.payritMint : Color.payritIntensivePink))
                            Text(homeStore.certificates[index].state.rawValue + "(\(Int(homeStore.certificates[index].progressValue))%)")
                                .font(Font.caption02)
                                .foregroundStyle(Color.gray04)
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 170)
                    .frame(maxWidth: .infinity)
                    .background(homeStore.certificates[index].cardColor == Color.payritMint ? Color.payritLightMint : Color.payritIntensiveLightPink)
                    .clipShape(.rect(cornerRadius: 12))
                    
                    // 내보내기 버튼
                    VStack(spacing: 6) {
                        if homeStore.certificates[index].cardColor == .payritMint {
//                        if true {
                            Button {
                            } label: {
                                HStack {
                                    Image(systemName: "tag")
                                    Text("전체 상환 기록")
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                                .background(Color.payritMint)
                                .clipShape(.rect(cornerRadius: 8))
                            }
                            NavigationLink {
                                CertificateDeductibleView(index: index)
                                    .customBackbutton()
                            } label: {
                                HStack {
                                    Image(systemName: "tag")
                                    Text("일부 상환 기록")
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.payritMint)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.payritMint, lineWidth: 2)
                                )
                            }
                            Button {
                                isActionSheetPresented.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "paperplane")
                                    Text("상환 재촉하기")
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.payritMint)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.payritMint, lineWidth: 2)
                                )
                            }
                            Button {
                                isActionSheetPresented.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "doc")
                                    Text("PDF·메일 내보내기")
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.payritMint)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.payritMint, lineWidth: 2)
                                    )
                            }
                        } else {
                            Button {
                                isActionSheetPresented.toggle()
                            } label: {
                                HStack {
                                    Image(systemName: "doc")
                                    Text("PDF·메일 내보내기")
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color.payritIntensivePink)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.payritIntensivePink, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .font(Font.body03)
                    .padding(.horizontal, 9)
                    .padding(.vertical, 16)
                }
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.2), radius: 5)
                .padding(.top, 24)
                
                HStack {
                    Button {
                        isModalPresented.toggle()
                    } label: {
                        Rectangle()
                            .foregroundStyle(homeStore.certificates[index].cardColor == .payritMint ? Color.payritLightMint : Color.payritIntensiveLightPink)
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
                        CertificateMemoView(index: index)
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
                                    Text("\(homeStore.certificates[index].creditorName)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].creditorPhoneNumber)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].creditorAddress)")
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
                                    Text("\(homeStore.certificates[index].debtorName)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].debtorPhoneNumber)")
                                }
                                HStack {
                                    Text("\(homeStore.certificates[index].debtorAddress)")
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
        .certificateToDoucument(isPresented: $isModalPresented, isButtonShowing: .constant(true))
        .onAppear {
        }
        .confirmationDialog("", isPresented: $isActionSheetPresented, titleVisibility: .hidden) {
            Button("PDF 다운") {
                pdfURL = homeStore.generatePDF()
                isShowingPDFView.toggle()
            }
            Button("이메일 전송") {
                if MFMailComposeViewController.canSendMail() {
                    pdfURL = homeStore.generatePDF()
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
            MailView(result: self.$result) { mailComposer in
                mailComposer.setSubject("\(Date().dateToString()) 페이릿 차용증")
                mailComposer.setToRecipients([""])
                mailComposer.setMessageBody("", isHTML: false)
                
                if let pdfURL = pdfURL, let pdfData = try? Data(contentsOf: pdfURL) {
                    mailComposer.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "\(Date().dateToString()) 페이릿 차용증.pdf")
                } else {
                    print("PDF 메일 오류")
                }
            }
        }
        .sheet(isPresented: $isShowingPDFView, content: {
            if let pdfURL = pdfURL {
                PDFKitView(url: pdfURL)
                ShareLink("PDF로 내보내기", item: pdfURL)
            }
        })
    }
}

#Preview {
    NavigationStack {
        CertificateDetailView(index: 0)
            .environment(HomeStore())
    }
}
