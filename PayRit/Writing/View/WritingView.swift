//
//  WritingView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Rectangle()
                    .frame(height: 160)
                    .foregroundStyle(Color.boxGrayColor)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("차용증 작성하기")
                                    .bold()
                                Spacer()
                                NavigationLink {
                                    SelectDocumentTypeView()
                                        .customBackbutton()
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.black)
                                }
                            }
                            .font(.system(size: 26))
                            Spacer()
                            Text("작성 시 본인인증이 필요해요.")
                        }
                        .padding(22)
                    }
                Rectangle()
                    .frame(height: 160)
                    .foregroundStyle(Color.boxGrayColor)
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("약속 작성하기")
                                    .bold()
                                Spacer()
                                NavigationLink {
                                    
                                } label: {
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.black)
                                }
                            }
                            .font(.system(size: 26))
                            Spacer()
                            Text("곧 출시되요!")
                        }
                        .padding(22)
                    }
                    .opacity(0.3)
                    .disabled(true)
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        Spacer().frame(height: 20)
                        Text("작성하기")
                            .font(.navigationTitleSize28)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    WritingView()
}
