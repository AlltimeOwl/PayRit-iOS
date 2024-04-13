//  CertificateDetailView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.

import SwiftUI
import UIKit
import MessageUI

struct CertificateDetailView: View {
    let paperId: Int
    let certificateStep: CertificateStep
    @State private var isLoading: Bool = true
    @State private var isShowingExportView: Bool = false
    @State private var isShowingPDFView: Bool = false
    @State private var isShowingMailView: Bool = false
    @State private var isShowingRemindAlert: Bool = false
    @State private var isShowingUnReadyAlert: Bool = false
    @State private var isShowingAllRepaymentAlert: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @Environment(HomeStore.self) var homeStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
//            if isLoading {
//                ProgressView()
//            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            if homeStore.certificateDetail.memberRole == "CREDITOR" {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(homeStore.certificateDetail.debtorProfile.name)님께")
                                    HStack(spacing: 0) {
                                        Text("총 ")
                                        Text(homeStore.certificateDetail.paperFormInfo.amountFormatter)
                                            .foregroundStyle(Color.payritMint)
                                        Text("원을 빌려주었어요.")
                                    }
                                }
                                .font(Font.title03)
                            } else {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(homeStore.certificateDetail.creditorProfile.name)님께")
                                    HStack(spacing: 0) {
                                        Text("총 ")
                                        Text(homeStore.certificateDetail.paperFormInfo.amountFormatter)
                                            .foregroundStyle(Color.payritIntensivePink)
                                        Text("원을 빌렸어요.")
                                    }
                                }
                                .font(Font.title03)
                            }
                            Spacer()
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("원금상환일   \(homeStore.certificateDetail.paperFormInfo.repaymentEndDate.stringDateToKorea())")
                                    .font(Font.caption01)
                                Spacer()
                                Text(homeStore.certificateDetail.dueDate >= 0 ? "D - \(homeStore.certificateDetail.dueDate)" : "D + \(-homeStore.certificateDetail.dueDate)")
                                    .font(Font.custom("SUIT-Bold", size: 14))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .background(homeStore.certificateDetail.memberRole == "CREDITOR" ? Color(hex: "00C2BD") : Color(hex: "F95873"))
                            .clipShape(.rect(cornerRadius: 8))
                            .padding(.top, 14)
                            
                            Text("남은 금액")
                                .font(Font.custom("SUIT-Bold", size: 14))
                                .padding(.top, 12)
                            
                            Text((homeStore.certificateDetail.paperFormInfo.remainingAmountFormatter) + "원")
                                .font(Font.custom("SUIT-ExtraBold", size: 26))
                                .padding(.top, 2)
                            
                            VStack(alignment: .trailing, spacing: 0) {
                                ProgressView(value: homeStore.certificateDetail.repaymentRate, total: 100)
                                    .progressViewStyle(CustomLinearProgressViewStyle(trackColor: .white, progressColor: homeStore.certificateDetail.memberRole == "CREDITOR" ? Color(hex: "00C2BD") : Color(hex: "F95873")))
                                    .frame(height: 6)
                                    .padding(.top, 12)
                                
                                Text("\(certificateStep.rawValue) (\(Int(homeStore.certificateDetail.repaymentRate))%)")
                                    .font(Font.caption01)
                                    .padding(.top, 4)
                                    .padding(.bottom, 12)
                            }
                        }
                        .padding(.horizontal, 14)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .background(homeStore.certificateDetail.memberRole == "CREDITOR" ? Color.payritMint : Color.payritIntensivePink)
                        .clipShape(.rect(cornerRadius: 12))
                        .padding(.top, 24)
                        
                        VStack(spacing: 0) {
                            if homeStore.certificateDetail.memberRole == "CREDITOR" {
                                VStack(spacing: 0) {
                                    HStack {
                                        Button {
                                            isShowingAllRepaymentAlert.toggle()
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("전체 상환")
                                                        .font(Font.title06)
                                                        .foregroundStyle(.black)
                                                    Text("기록하기")
                                                        .font(Font.body03)
                                                        .foregroundStyle(Color.gray05)
                                                }
                                                Spacer()
                                                Image("cash")
                                            }
                                        }
                                        
                                        Spacer()
                                        Rectangle()
                                            .foregroundStyle(Color.gray08)
                                            .frame(width: 2)
                                            .background()
                                            .frame(width: 20, height: 40)
                                        Spacer()
                                        
                                        NavigationLink {
                                            CertificateDeductibleView(certificateDetail: homeStore.certificateDetail)
                                                .customBackbutton()
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("일부 상환")
                                                        .font(Font.title06)
                                                        .foregroundStyle(.black)
                                                    Text("기록하기")
                                                        .font(Font.body03)
                                                        .foregroundStyle(Color.gray05)
                                                }
                                                Spacer()
                                                Image("coins")
                                            }
                                        }
                                    }
                                    .frame(height: 48)
                                    .padding(.bottom, 12)
                                    
                                    Rectangle()
                                        .foregroundStyle(Color.gray08)
                                        .frame(height: 2)
                                        .background()
                                        .frame(height: 14)
                                    
                                    HStack {
                                        Button {
                                            isShowingRemindAlert.toggle()
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("상환 알림")
                                                        .font(Font.title06)
                                                        .foregroundStyle(.black)
                                                    Text("재촉하기")
                                                        .font(Font.body03)
                                                        .foregroundStyle(Color.gray05)
                                                }
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                        Rectangle()
                                            .foregroundStyle(Color.gray08)
                                            .frame(width: 2)
                                            .background()
                                            .frame(width: 20, height: 40)
                                        Spacer()
                                        
                                        Button {
                                            isShowingExportView.toggle()
                                        } label: {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 6) {
                                                    Text("PDF·이메일")
                                                        .font(Font.title06)
                                                        .foregroundStyle(.black)
                                                    Text("내보내기")
                                                        .font(Font.body03)
                                                        .foregroundStyle(Color.gray05)
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                    .frame(height: 48)
                                    .padding(.top, 12)
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background()
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                                
                            } else {
                                Button {
                                    isShowingExportView.toggle()
                                } label: {
                                    HStack(spacing: 0) {
                                        Text("PDF·이메일")
                                            .font(Font.title06)
                                        Spacer()
                                        Text("내보내기")
                                            .font(Font.body01)
                                            .foregroundStyle(Color.gray05)
                                    }
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 26)
                                    .padding(.horizontal, 12)
                                    .background()
                                    .clipShape(.rect(cornerRadius: 12))
                                    .shadow(color: .gray.opacity(0.2), radius: 5)
                                }
                            }
                        }
                        .padding(.vertical, 24)
                        
                        NavigationLink {
                            CertificateMemoView(paperId: paperId)
                                .customBackbutton()
                        } label: {
                            HStack(spacing: 0) {
                                Text("개인 메모")
                                    .font(Font.body01)
                                Spacer()
                                Text("\(homeStore.certificateDetail.memoListResponses.count)건 >")
                                    .font(Font.title06)
                            }
                            .foregroundStyle(.black)
                            .padding(.vertical, 26)
                            .padding(.horizontal, 12)
                            .background()
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                        }
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("빌려준 사람")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray05)
                                HStack {
                                    HStack {
                                        Text("이름")
                                            .font(Font.body04)
                                        Spacer()
                                    }
                                    .frame(width: 60)
                                    Text("\(homeStore.certificateDetail.creditorProfile.name)")
                                        .font(Font.body01)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    HStack {
                                        Text("연락처")
                                            .font(Font.body04)
                                        Spacer()
                                    }
                                    .frame(width: 60)
                                    Text("\(homeStore.certificateDetail.creditorProfile.phoneNumber.onlyPhoneNumber())")
                                        .font(Font.body01)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                                
                                if !homeStore.certificateDetail.creditorProfile.address.isEmpty {
                                    HStack(alignment: .top) {
                                        HStack {
                                            Text("주소")
                                                .font(Font.body04)
                                            Spacer()
                                        }
                                        .frame(width: 60)
                                        Text("\(homeStore.certificateDetail.creditorProfile.address)")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .padding(.leading, 8)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("빌린 사람")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray05)
                                HStack {
                                    HStack {
                                        Text("이름")
                                            .font(Font.body04)
                                        Spacer()
                                    }
                                    .frame(width: 60)
                                    Text("\(homeStore.certificateDetail.debtorProfile.name)")
                                        .font(Font.body01)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                                
                                HStack {
                                    HStack {
                                        Text("연락처")
                                            .font(Font.body04)
                                        Spacer()
                                    }
                                    .frame(width: 60)
                                    Text("\(homeStore.certificateDetail.debtorProfile.phoneNumber.onlyPhoneNumber())")
                                        .font(Font.body01)
                                    Spacer()
                                }
                                .padding(.leading, 8)
                                
                                if !homeStore.certificateDetail.debtorProfile.address.isEmpty {
                                    HStack(alignment: .top) {
                                        HStack {
                                            Text("주소")
                                                .font(Font.body04)
                                            Spacer()
                                        }
                                        .frame(width: 60)
                                        Text("\(homeStore.certificateDetail.debtorProfile.address)")
                                            .font(Font.body01)
                                        Spacer()
                                    }
                                    .padding(.leading, 8)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .shadow(color: .gray.opacity(0.2), radius: 5)
                            
                            if homeStore.certificateDetail.paperFormInfo.interestRate > 0 || homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 || homeStore.certificateDetail.paperFormInfo.specialConditions != nil {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("추가사항")
                                        .font(Font.body03)
                                        .foregroundStyle(homeStore.certificateDetail.memberRole == "CREDITOR" ? Color.payritMint : Color.payritIntensivePink)
                                    
                                    if homeStore.certificateDetail.paperFormInfo.interestRate > 0 {
                                        HStack {
                                            HStack {
                                                Text("이자율")
                                                    .font(Font.body04)
                                                Spacer()
                                            }
                                            .frame(width: 80)
                                            Text("\(String(format: "%.2f", homeStore.certificateDetail.paperFormInfo.interestRate))%")
                                                .font(Font.body01)
                                            Spacer()
                                        }
                                        .padding(.leading, 8)
                                    }
                                    
                                    if homeStore.certificateDetail.paperFormInfo.interestPaymentDate != 0 {
                                        HStack {
                                            HStack {
                                                Text("이자 지급일")
                                                    .font(Font.body04)
                                                Spacer()
                                            }
                                            .frame(width: 80)
                                            Text("매월 \(homeStore.certificateDetail.paperFormInfo.interestPaymentDate)일")
                                                .font(Font.body01)
                                            Spacer()
                                        }
                                        .padding(.leading, 8)
                                    }
                                    if let specialConditions = homeStore.certificateDetail.paperFormInfo.specialConditions {
                                        HStack(alignment: .top) {
                                            HStack {
                                                Text("특이사항")
                                                    .font(Font.body04)
                                                Spacer()
                                            }
                                            .frame(width: 80)
                                            Text("\(specialConditions)")
                                                .font(Font.body01)
                                            Spacer()
                                        }
                                        .padding(.leading, 8)
                                    }
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(.rect(cornerRadius: 12))
                                .shadow(color: .gray.opacity(0.2), radius: 5)
                            }
                        }
                        .padding(.top, 24)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }
                .scrollIndicators(.hidden)
                .navigationTitle("페이릿 상세 페이지")
                .navigationBarTitleDisplayMode(.inline)
                .redacted(reason: isLoading ? .placeholder : [])
//            }
        }
        .dismissOnDrag()
        .onAppear {
            isLoading = true
            Task {
                await homeStore.loadDetail(id: paperId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        self.isLoading = false
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            let pdfURL: URL? = homeStore.generatePDF()
            MailView(result: self.$result) { mailComposer in
                mailComposer.setSubject("\(Date().dateToString()) 페이릿 차용증")
                mailComposer.setToRecipients([""])
                mailComposer.setMessageBody("", isHTML: false)
                if let url = pdfURL, let pdfData = try? Data(contentsOf: url) {
                    mailComposer.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "\(Date().dateToString()) 페이릿 차용증.pdf")
                } else {
                    print("PDF 메일 오류")
                }
            }
        }
        .sheet(isPresented: $isShowingPDFView, content: {
            let pdfURL: URL? = homeStore.generatePDF()
            if let url = pdfURL {
                PDFKitView(url: url)
                ShareLink("PDF로 내보내기", item: url)
            }
        })
        .certificateToDoucument(isPresented: $isShowingExportView, primaryAction: {
            isShowingExportView.toggle()
            isShowingPDFView.toggle()
        }, primaryAction2: {
            if MFMailComposeViewController.canSendMail() {
                isShowingExportView.toggle()
                isShowingMailView.toggle()
            } else {
                print("메일을 보낼수 없는 기기입니다.")
            }
            if result != nil {
                print("Result: \(String(describing: result))")
            }
        })
        .primaryAlert(isPresented: $isShowingAllRepaymentAlert, title: "전체 상환 기록", content: "남은 금액 \(homeStore.certificateDetail.paperFormInfo.remainingAmountFormatter)원을 전체 상환 하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            if homeStore.certificateDetail.paperFormInfo.remainingAmount > 0 {
                homeStore.deductedSave(paperId: paperId, repaymentDate: Date().dateToString(), repaymentAmount:  String(homeStore.certificateDetail.paperFormInfo.remainingAmount)) { (array, error) in
                    if let error = error {
                        print("Error occurred: \(error)")
                    } else if let deducted = array {
                        print("adsdasd \(deducted)")
                    }
                }
                homeStore.certificateDetail.paperFormInfo.remainingAmount = 0
                homeStore.certificateDetail.repaymentRate = 100.0
                homeStore.certificateDetail.repaymentHistories.append(Deducted(id: 0, repaymentDate: Date().dateToString().replacingOccurrences(of: "-", with: "."), repaymentAmount: homeStore.certificateDetail.paperFormInfo.remainingAmount))
            }
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingRemindAlert, title: "문자로 재촉하기", content: "상환 요청 메시지를 문자(MMS)로 전송하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            isShowingUnReadyAlert.toggle()
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingUnReadyAlert, title: "재촉하기 준비중입니다.", content: "빠른 시일 내에 제공드리겠습니다.", primaryButtonTitle: nil, cancleButtonTitle: "네") {
        } cancleAction: {
        }
        
    }
}

#Preview {
    NavigationStack {
        CertificateDetailView(paperId: 0, certificateStep: .progress)
            .environment(HomeStore())
    }
}
