//
//  CertificateDocumentView.swift
//  PayRit
//
//  Created by 임대진 on 3/14/24.
//

import SwiftUI

struct CertificateDocumentView: View {
    var body: some View {
        VStack {
            Text("차   용   증")
                .font(.title)
                .padding(.top, 60)
            
            HStack {
                VStack(spacing: 8) {
                    Text("채 권 자")
                    Text("채 권 자")
                        .foregroundStyle(.clear)
                    Text("채 권 자")
                        .foregroundStyle(.clear)
                    Text("채 무 자")
                    Text("채 무 자")
                        .foregroundStyle(.clear)
                    Text("채 무 자")
                        .foregroundStyle(.clear)
                }
                VStack(spacing: 8) {
                    HStack {
                        Text("성 명 : ")
                        Text("")
                        Spacer()
                    }
                    HStack {
                        Text("전화번호 : ")
                        Text("")
                        Spacer()
                    }
                    HStack {
                        Text("주 소 : ")
                        Text("")
                        Spacer()
                    }
                    HStack {
                        Text("성 명 : ")
                        Text("")
                        Spacer()
                    }
                    HStack {
                        Text("전화번호 : ")
                        Text("")
                        Spacer()
                    }
                    HStack {
                        Text("주 소 : ")
                        Text("")
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
                    .frame(width: 100)
                    .bold()
                    Divider()
                        .foregroundStyle(.black)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("원금")
                            Spacer()
                            Text("원정 (")
                            Text(")")
                        }
                        .padding(.horizontal, 10)
                        Divider()
                            .foregroundStyle(.black)
                        HStack {
                            Spacer()
                            Text("연 ( )%")
                            Spacer()
                            Divider()
                                .foregroundStyle(.black)
                            Spacer()
                            Text("매월 ( ) 일에 지급")
                            Spacer()
                        }
                        Divider()
                            .foregroundStyle(.black)
                        Text(" 년 월 일")
                            .padding(.horizontal, 10)

                        Divider()
                            .foregroundStyle(.black)
                        Text("없음")
                            .padding(.horizontal, 10)

                    }
                    .padding(.vertical, 10)
                }
            }
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
            
            Text("2024년 00월 00일")
                .padding(.top, 100)
            Spacer()
            HStack {
                Spacer()
                Text("채 권 자 :                  (인)")
                    .padding(.trailing, 40)
            }
            .padding(.bottom, 20)
            HStack {
                Spacer()
                Text("채 무 자 :                  (인)")
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
    CertificateDocumentView()
}