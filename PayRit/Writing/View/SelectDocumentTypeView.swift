//
//  SelectDocumentTypeView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct SelectDocumentTypeView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("현재, 어떤 상황인가요?")
                .font(.system(size: 26))
            HStack {
                Button {
                    
                } label: {
                    Rectangle()
                        .foregroundStyle(Color.boxGrayColor)
                        .clipShape(.rect(cornerRadius: 12))
                        .frame(height: 160)
                        .overlay {
                            Text("""
                                 빌려줄
                                 예정이에요
                                 """)
                            .lineSpacing(10.0)
                                .font(.system(size: 24))
                                .bold()
                                .foregroundStyle(.black)
                        }
                }
                Spacer()
                    .frame(width: 18)
                Button {
                    
                } label: {
                    Rectangle()
                        .foregroundStyle(Color.boxGrayColor)
                        .clipShape(.rect(cornerRadius: 12))
                        .frame(height: 160)
                        .overlay {
                            Text("""
                                 빌릴
                                 예정이에요
                                 """)
                            .lineSpacing(10.0)
                                .font(.system(size: 24))
                                .bold()
                                .foregroundStyle(.black)
                        }
                }
            }
            .padding(.top, 16)
            
            Rectangle()
                .foregroundStyle(Color.writingGuideBoxColor)
                .clipShape(.rect(cornerRadius: 12))
                .frame(height: 160)
                .overlay {
                    VStack {
                        HStack {
                            Text("🍯 작성 가이드")
                            .lineSpacing(10.0)
                                .font(.system(size: 20))
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(15)
                }
                .padding(.top, 40)
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
        .navigationTitle("차용증 작성하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SelectDocumentTypeView()
    }
}
