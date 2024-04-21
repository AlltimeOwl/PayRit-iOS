//
//  SelectPromiseTypeView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI

struct SelectPromiseTypeView: View {
    @State private var isShowingNextView: Bool = false
    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("오늘은")
                    HStack(spacing: 0) {
                        ZStack {
                            VStack {
                                Spacer()
                                Rectangle()
                                    .frame(width: 100, height: 8)
                                    .foregroundStyle(Color.payritLightMint)
                            }
                            Text("어떤 약속")
                        }
                        Text("을 진행할까요?")
                    }
                    .frame(height: 20)
                }
                .font(Font.title01)
                Spacer()
            }
            .padding(.bottom, 30)
            
            VStack(spacing: 20) {
                Button {
                    isShowingNextView.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 160)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        .overlay(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("약속 카드 만들기")
                                            .font(Font.title02)
                                            .foregroundStyle(.black)
                                        Spacer()
                                    }
                                    Spacer()
                                    Text("간단한 돈 약속 카드를\n제작해서 간직할 수 있어요")
                                        .font(Font.body04)
                                        .foregroundStyle(Color.gray05)
                                        .multilineTextAlignment(.leading)
                                }
                                Image("calender")
                            }
                            .frame(height: 92)
                            .padding(22)
                        }
                }
                
                NavigationLink {
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 160)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 12))
                        .customShadow()
                        .overlay(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("결제 카드 뽑기")
                                            .font(Font.title02)
                                            .foregroundStyle(.black)
                                        Spacer()
                                    }
                                    Spacer()
                                    Text("결제할 사람의 카드를\n뽑을 수 있어요")
                                        .font(Font.body04)
                                        .foregroundStyle(Color.gray05)
                                        .multilineTextAlignment(.leading)
                                }
                                Image("card")
                            }
                            .frame(height: 92)
                            .padding(22)
                        }
                }
            }
            .padding(.top, 16)
            Spacer()
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
        .navigationTitle("약속 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isShowingNextView) {
            
                ContactAddView(path: $path)
        }
    }
}

#Preview {
    SelectPromiseTypeView(path: .constant(NavigationPath()))
}
