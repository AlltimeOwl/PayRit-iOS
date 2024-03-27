//
//  CertificateDocumentView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateDocumentView: View {
//    let certificateDetail = CertificateDetail(paperId: 0, paperUrl: "",memberRole: "", primeAmount: 200000,interest: 20000, amount: 220000, remainingAmount: 10000000, interestRate: 10.0, interestPaymentDate: 15, repaymentRate: 0.0, repaymentStartDate: "2024.01.01", repaymentEndDate: "2024.04.01", creditorName: "임대진", creditorPhoneNumber: "010.5009.7937", creditorAddress: "경기도 용인시 수지구 신봉동 876", dueDate: 10, debtorName: "홍길동", debtorPhoneNumber: "010.1919.1919", debtorAddress: "경기도 용인시 수지구 신봉동 192930", specialConditions: "특약사항", memoListResponses: [Memo](), repaymentHistories: [Deducted]())
    let certificateDetail: CertificateDetail
    var body: some View {
        VStack {
            Text("차   용   증")
                .font(.title)
                .padding(.top, 100)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("채 권 자")
                    Spacer()
                }
                .frame(height: 60)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("성 명 : ")
                    }
                    HStack {
                        Text("전화번호 : ")
                    }
                    HStack {
                        Text("주 소 : ")
                    }
                }
                .frame(width: 50, height: 60)
                VStack(spacing: 8) {
                    HStack {
                        Text("\(certificateDetail.creditorName)")
                        Spacer()
                    }
                    HStack {
                        Text("\(certificateDetail.creditorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                        Spacer()
                    }
                    HStack {
                        Text("\(certificateDetail.creditorAddress)")
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 6)
            HStack {
                VStack(alignment: .leading) {
                    Text("채 무 자")
                    Spacer()
                }
                .frame(height: 60)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("성 명 : ")
                    }
                    HStack {
                        Text("전화번호 : ")
                    }
                    HStack {
                        Text("주 소 : ")
                    }
                }
                .frame(width: 50, height: 60)
                VStack(spacing: 8) {
                    HStack {
                        Text("\(certificateDetail.debtorName)")
                        Spacer()
                    }
                    HStack {
                        Text("\(certificateDetail.debtorPhoneNumber.onlyPhoneNumber().replacingOccurrences(of: "-", with: "."))")
                        Spacer()
                    }
                    HStack {
                        Text("\(certificateDetail.debtorAddress)")
                        Spacer()
                    }
                }
            }
            .padding(.vertical, 6)
            
            HStack {
                Text("차용금액 및 변제조건")
                    .bold()
                Spacer()
            }
            .padding(.top, 20)
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 0) {
                    VStack {
                        Text("원금")
                        Divider()
                            .foregroundStyle(.black)
                        Text("이자 및 지급일")
                        Divider()
                            .foregroundStyle(.black)
                        Text("원금 상환일")
                        Divider()
                            .foregroundStyle(.black)
                        Text("특약사항")
                    }
                    .padding(.vertical, 10)
                    .frame(width: 80)
                    .bold()
                    Divider()
                        .foregroundStyle(.black)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("원금  \(certificateDetail.amount.numberToKorean())  원정")
                            Spacer()
                            Text("(  \(certificateDetail.amount)  원 )")
                        }
                        .padding(.horizontal, 10)
                        Divider()
                            .foregroundStyle(.black)
                        HStack {
                            Text("연 ( \(String(format: "%.2f", certificateDetail.interestRate)) % )")
                            Spacer()
                            Divider()
                                .foregroundStyle(.black)
                            Spacer()
                            Text("매월 ( \(certificateDetail.interestPaymentDate) 일 ) 에 지급")
                        }
                        .padding(.horizontal, 10)
                        Divider()
                            .foregroundStyle(.black)
                        Text("\(certificateDetail.repaymentEndDate)")
                            .padding(.horizontal, 10)

                        Divider()
                            .foregroundStyle(.black)
                        if let etc = certificateDetail.specialConditions {
                            Text(etc)
                                .padding(.horizontal, 10)
                        } else {
                            Text("etc")
                                .padding(.horizontal, 10)
                                .foregroundStyle(.clear)
                        }

                    }
                    .padding(.vertical, 10)
                }
            }
            .font(.system(size: 10))
            .border(Color.black)
            .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                }
                Text("채무자는 이와 같은 조건으로, 채권자로부터 틀림없이 위 돈을 차용하였음을 확인하고, 변제할 것을 확약합니다.")
                    .lineSpacing(6)
            }
            .frame(height: 50)
            .padding(.top, 50)
            
            Text(certificateDetail.transactionDate.stringDateToKorea())
                .padding(.vertical, 40)
            Spacer()
            HStack {
                Spacer()
                Text("채 권 자 :    \(certificateDetail.creditorName)    (인)")
                    .padding(.trailing, 40)
            }
            .padding(.vertical, 10)
            HStack {
                Spacer()
                Text("채 무 자 :    \(certificateDetail.debtorName)    (인)")
                    .padding(.trailing, 40)
            }
            Spacer()
        }
        .font(.system(size: 12))
        .padding(.horizontal, 30)
        .padding(.bottom, 160)
    }
}

#Preview {
    CertificateDocumentView(certificateDetail: CertificateDetail.EmptyCertificate)
}
