//
//  SelectCertificateTypeView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct SelectCertificateTypeView: View {
    @Binding var path: NavigationPath
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                Text("현재, 어떤 상황인가요?")
                    .font(Font.title03)
                HStack {
                    NavigationLink {
                        WritingCertificateInfoView(certificateType: .constant(.CREDITOR), path: $path)
                            .customBackbutton()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.payritLightMint, lineWidth: 2.0)
                            .frame(height: 160)
                            .overlay {
                                Text("""
                                 빌려줄
                                 예정이에요
                                 """)
                                .lineSpacing(6)
                                .font(Font.title05)
                                .foregroundStyle(Color.gray02)
                            }
                    }
                    Spacer()
                        .frame(width: 18)
                    NavigationLink {
                        WritingCertificateInfoView(certificateType: .constant(.DEBTOR), path: $path)
                            .customBackbutton()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.payritIntensiveLightPink, lineWidth: 2.0)
                            .frame(height: 160)
                            .overlay {
                                Text("""
                                 빌릴
                                 예정이에요
                                 """)
                                .lineSpacing(6)
                                .font(Font.title05)
                                .foregroundStyle(Color.gray02)
                            }
                    }
                }
                .padding(.top, 16)
            }
            .padding(.top, 40)
            .padding(.horizontal, 16)
        }
        .dismissOnDrag()
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SelectCertificateTypeView(path: .constant(NavigationPath()))
    }
}
