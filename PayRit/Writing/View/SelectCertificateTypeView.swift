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
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("현재,\n어떤 상황인가요?")
                }
                .font(Font.title01)
                .padding(.bottom, 30)
                
                VStack(spacing: 20) {
                    NavigationLink {
                        WritingCertificateInfoView(certificateType: "CREDITOR", path: $path)
                            .customBackbutton()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 32) {
                                    HStack(spacing: 0) {
                                        ZStack {
                                            VStack {
                                                Spacer()
                                                Rectangle()
                                                    .frame(width: 110, height: 8)
                                                    .foregroundStyle(Color.payritLightMint)
                                            }
                                            Text("돈을 빌려줬")
                                        }
                                        Text("어요")
                                    }
                                    .font(Font.title02)
                                    .foregroundStyle(.black)
                                    .frame(height: 20)
                                    
                                    Text("빌려주는 사람 기준으로 작성돼요.")
                                        .font(Font.body04)
                                        .foregroundStyle(Color.gray05)
                                }
                                .frame(height: 92)
                                .padding(22)
                            }
                    }
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                    
                    NavigationLink {
                        WritingCertificateInfoView(certificateType: "DEBTOR", path: $path)
                            .customBackbutton()
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 160)
                            .foregroundStyle(.white)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay(alignment: .leading) {
                                VStack(alignment: .leading, spacing: 32) {
                                    HStack(spacing: 0) {
                                        ZStack {
                                            VStack {
                                                Spacer()
                                                Rectangle()
                                                    .frame(width: 90, height: 8)
                                                    .foregroundStyle(Color.payritIntensiveLightPink)
                                            }
                                            Text("돈을 빌렸")
                                        }
                                        Text("어요")
                                    }
                                    .font(Font.title02)
                                    .foregroundStyle(.black)
                                    .frame(height: 20)
                                    
                                    Text("빌리는 사람 기준으로 작성돼요.")
                                        .font(Font.body04)
                                        .foregroundStyle(Color.gray05)
                                }
                                .frame(height: 92)
                                .padding(22)
                                
                            }
                    }
                    .shadow(color: .gray.opacity(0.2), radius: 8)
                }
                .padding(.top, 16)
                Spacer()
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
