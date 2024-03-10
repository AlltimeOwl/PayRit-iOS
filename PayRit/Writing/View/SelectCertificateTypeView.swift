//
//  SelectCertificateTypeView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct SelectCertificateTypeView: View {
    @Binding var tabBarVisivility: Visibility
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            Text("현재, 어떤 상황인가요?")
                .font(Font.title03)
            HStack {
                NavigationLink {
                    WritingCertificateInfoView(certificateType: .constant(.iLentYou), path: $path)
                        .customBackbutton()
                } label: {
                    Rectangle()
                        .foregroundStyle(Color.gray08)
                        .clipShape(.rect(cornerRadius: 12))
                        .frame(height: 160)
                        .overlay {
                            Text("""
                                 빌려줄
                                 예정이에요
                                 """)
                            .lineSpacing(6)
                            .font(Font.title05)
                            .foregroundStyle(.black)
                        }
                }
                Spacer()
                    .frame(width: 18)
                NavigationLink {
                    WritingCertificateInfoView(certificateType: .constant(.iBorrowed), path: $path)
                        .customBackbutton()
                } label: {
                    Rectangle()
                        .foregroundStyle(Color.gray08)
                        .clipShape(.rect(cornerRadius: 12))
                        .frame(height: 160)
                        .overlay {
                            Text("""
                                 빌릴
                                 예정이에요
                                 """)
                            .lineSpacing(6)
                            .font(Font.title05)
                            .foregroundStyle(.black)
                        }
                }
            }
            .padding(.top, 16)
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            tabBarVisivility = .hidden
        }
    }
}

#Preview {
    NavigationStack {
        SelectCertificateTypeView(tabBarVisivility: .constant(.visible), path: .constant(NavigationPath()))
    }
}
