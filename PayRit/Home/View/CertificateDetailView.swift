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
    var isFormValid: Bool = false
    @State private var isLoading: Bool = true
    @State private var isShowingExportView: Bool = false
    @State private var isShowingPDFView: Bool = false
    @State private var isShowingMailView: Bool = false
    @State private var isShowingAllRepaymentAlert: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>?
    @Environment(HomeStore.self) var homeStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            if isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        HStack {
                            if homeStore.certificateDetail.memberRole == "CREDITOR" {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(homeStore.certificateDetail.debtorName)님께")
                                    HStack(spacing: 0) {
                                        Text("총 ")
                                        Text(homeStore.certificateDetail.amountFormatter)
                                            .foregroundStyle(Color.payritMint)
                                        Text("원을 빌려주었어요.")
                                    }
                                }
                                .font(Font.title03)
                            } else {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(homeStore.certificateDetail.creditorName)님께")
                                    HStack(spacing: 0) {
                                        Text("총 ")
                                        Text(homeStore.certificateDetail.amountFormatter)
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
                                    Text("원금상환일 \(homeStore.certificateDetail.repaymentEndDate.replacingOccurrences(of: "-", with: "."))")
                                        .font(Font.caption02)
                                        .foregroundStyle(Color.gray02)
                                    Spacer()
                                }
                                .padding(.top, 16)
                                
                                Text("남은 금액")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                    .padding(.top, 14)
                                
                                Text(String(homeStore.certificateDetail.remainingAmountFormatter) + "원")
                                    .font(Font.title01)
                                    .padding(.top, 2)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    HStack { Spacer() }
                                    Text(homeStore.certificateDetail.dueDate >= 0 ? "D - \(homeStore.certificateDetail.dueDate)" : "D + \(-homeStore.certificateDetail.dueDate)")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray02)
                                    ProgressView(value: homeStore.certificateDetail.repaymentRate, total: 100)
                                        .progressViewStyle(CustomLinearProgressViewStyle(trackColor: Color.gray09, progressColor: homeStore.certificateDetail.memberRole == "CREDITOR" ? Color.payritMint : Color.payritIntensivePink))
                                    Text("\(homeStore.certificateDetail.repaymentRate == 100.0 ? "상환 완료" : certificateStep.rawValue) (\(Int(homeStore.certificateDetail.repaymentRate))%)")
                                        .font(Font.caption02)
                                        .foregroundStyle(Color.gray04)
                                }
                                .padding(.bottom, 16)
                            }
                            .padding(.horizontal, 16)
                            .frame(height: 170)
                            .frame(maxWidth: .infinity)
                            .background(homeStore.certificateDetail.memberRole == "CREDITOR" ? Color.payritLightMint : Color.payritIntensiveLightPink)
                            .clipShape(.rect(cornerRadius: 12))
                            
                            // 내보내기 버튼
                            VStack(spacing: 6) {
                                if homeStore.certificateDetail.memberRole == "CREDITOR" {
                                    //                        if true {
                                    Button {
                                        isShowingAllRepaymentAlert.toggle()
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
                                        CertificateDeductibleView(certificateDetail: homeStore.certificateDetail)
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
                                        isShowingExportView.toggle()
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
                                        isShowingExportView.toggle()
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
                        
                        NavigationLink {
                            CertificateMemoView(certificateDetail: homeStore.certificateDetail)
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
                                        Text("총 \(homeStore.certificateDetail.memoListResponses.count)개의 메모")
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
                                        if !homeStore.certificateDetail.creditorAddress.isEmpty {
                                            HStack {
                                                Text("주소")
                                            }
                                        }
                                    }
                                    .font(Font.body04)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("\(homeStore.certificateDetail.creditorName)")
                                        }
                                        HStack {
                                            Text("\(homeStore.certificateDetail.creditorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                        }
                                        if !homeStore.certificateDetail.creditorAddress.isEmpty {
                                            HStack {
                                                Text("\(homeStore.certificateDetail.creditorAddress)")
                                            }
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
                                        if !homeStore.certificateDetail.debtorAddress.isEmpty {
                                            HStack {
                                                Text("주소")
                                            }
                                        }
                                    }
                                    .font(Font.body04)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("\(homeStore.certificateDetail.debtorName)")
                                        }
                                        HStack {
                                            Text("\(homeStore.certificateDetail.debtorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                                        }
                                        if !homeStore.certificateDetail.debtorAddress.isEmpty {
                                            HStack {
                                                Text("\(homeStore.certificateDetail.debtorAddress)")
                                            }
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
                            if homeStore.certificateDetail.interestRate != 0 || homeStore.certificateDetail.interestPaymentDate != 0 || homeStore.certificateDetail.specialConditions != nil {
                                VStack(alignment: .leading) {
                                    Text("추가사항")
                                        .font(Font.body03)
                                        .foregroundStyle(Color.gray04)
                                    VStack(alignment: .leading, spacing: 12) {
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
            }
        }
        .dismissOnDrag()
        .onAppear {
            Task {
                await homeStore.loadDetail(id: paperId)
                self.isLoading = false
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
        .primaryAlert(isPresented: $isShowingAllRepaymentAlert, title: "전체 상환 기록", content: "남은 금액 \(homeStore.certificateDetail.remainingAmountFormatter)원을 전체 상환 하시겠습니까?", primaryButtonTitle: "네", cancleButtonTitle: "아니오") {
            homeStore.deductedSave(paperId: paperId, repaymentDate: Date().dateToString(), repaymentAmount: String(homeStore.certificateDetail.remainingAmount))
            homeStore.certificateDetail.remainingAmount = 0
            homeStore.certificateDetail.repaymentRate = 100.0
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
