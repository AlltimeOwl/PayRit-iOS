//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedButton = true
    let testDocument = Document.samepleDocument
    var body: some View {
        VStack {
            HStack {
                Text("대진님의 기록")
                    .font(.system(size: 30))
                    .bold()
                Spacer()
                Image(systemName: "bell")
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            HStack(spacing: 0) {
                Button {
                    if selectedButton { return }
                    selectedButton.toggle()
                } label: {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 0, bottomTrailing: 0, topTrailing: 12))
                            .frame(height: 50)
                            .foregroundStyle(selectedButton ? Color.mainColor : Color.buttonCleanColor)
                        Text("빌려준 기록")
                            .foregroundStyle(selectedButton ? .black : .gray)
                    }
                }
                
                Button {
                    guard selectedButton else { return }
                    selectedButton.toggle()
                } label: {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 0, bottomTrailing: 0, topTrailing: 12))
                            .frame(height: 50)
                            .foregroundStyle(selectedButton ? Color.buttonCleanColor : Color.mainColor)
                        Text("빌린 기록")
                            .foregroundStyle(selectedButton ? .gray : .black)
                        
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.bottom, 17)
            .padding(.horizontal, 16)
            HStack {
                Text("총 \(testDocument.count)건")
                    .foregroundStyle(Color(hex: "#6F6F6F"))
                Spacer()
                ZStack {
                    //                    Capsule()
                    //                        .frame(width: 80, height: 34)
                }
            }
            .padding(.horizontal, 5)
            .padding(.horizontal, 16)
            //            Spacer()
            if selectedButton {
                //                Text("아직 거래 내역이 없어요")
                //
                List(testDocument) { document in
                    ZStack {
                        Rectangle()
                            .frame(height: 170)
                            .foregroundStyle(Color(hex: "#F5F5F5"))
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(document.startDay)
                                        Text("~")
                                        Text(document.endDay)
                                        Spacer()
                                        Button {
                                            
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .rotationEffect(.degrees(90))
                                        }
                                    }
                                    .padding(.top, 15)
                                    Text(String(document.totalMoney) + "원")
                                        .font(.system(size: 28))
                                        .bold()
                                        .padding(.top, 8)
                                    Text(document.recipient)
                                    HStack(spacing: 0) {
                                        Spacer()
                                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: 0, topTrailing: 0))
                                            .frame(width: 80)
                                            .foregroundStyle(Color(hex: "5F5F5F"))
                                            .overlay {
                                                Text(document.dDay)
                                                    .foregroundStyle(.white)
                                            }
                                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 16, topTrailing: 16))
                                            .frame(width: 140)
                                            .foregroundStyle(Color.mainColor)
                                            .overlay {
                                                Text("차용증 작성 완료")
                                                    .foregroundStyle(.white)
                                            }
                                    }
                                    .frame(height: 28)
                                    Spacer()
                                }
                                .padding(.horizontal, 14)
                            }
                        
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
            }
            Spacer()
        }
        .toolbar {
            //            ToolbarItem(placement: .topBarLeading) {
            //                Button {
            //                }label: {
            //                    Text("대진님의 기록")
            //                        .font(.system(size: 30))
            //                        .bold()
            //                        .foregroundStyle(.black)
            //                }
            //            }
            //            ToolbarItem(placement: .topBarTrailing) {
            //                Button {
            //                }label: {
            //                    Image(systemName: "bell")
            //                        .foregroundStyle(.black)
            //                }
            //            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
