//
//  WritingView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingView: View {
    @State var path = NavigationPath()
    @Binding var tabBarVisivility: Visibility
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                NavigationLink(value: "selectDocumentTypeView") {
                    Rectangle()
                        .frame(height: 160)
                        .foregroundStyle(Color.payritMint)
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("페이릿 작성하기")
                                        .font(Font.title01)
                                        .foregroundStyle(.white)
                                    Spacer()
                                }
                                Spacer()
                                Text("차용증과 동일한 효력을 가지고 있어요")
                                    .font(Font.body03)
                                    .foregroundStyle(.white)
                            }
                            .padding(22)
                        }
                        .shadow(color: .gray.opacity(0.2), radius: 5)
                }
                .navigationDestination(for: String.self) { _ in
                    SelectCertificateTypeView(tabBarVisivility: $tabBarVisivility, path: $path)
                        .customBackbutton()
                        .toolbar(tabBarVisivility, for: .tabBar)
                }
                
                NavigationLink {
                    
                } label: {
                    Rectangle()
                        .frame(height: 160)
                        .foregroundStyle(Color(hex: "FFFA86"))
                        .clipShape(.rect(cornerRadius: 12))
                        .overlay {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("약속 작성하기")
                                        .font(Font.title01)
                                    Spacer()
                                }
                                Spacer()
                                Text("곧 출시되요!")
                            }
                            .padding(22)
                            .foregroundStyle(.black)
                        }
                        .opacity(0.3)
                }
                .disabled(true)
                .shadow(color: .gray.opacity(0.2), radius: 5)
                
                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        Spacer().frame(height: 20)
                        Text("작성하기")
                            .font(Font.title01)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    VStack {
                        Spacer().frame(height: 20)
                        Image(systemName: "bell")
                    }
                }
            }
        }
    }
}

#Preview {
    WritingView(tabBarVisivility: .constant(.visible))
}
