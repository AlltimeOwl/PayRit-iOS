//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

enum MenuStateString: String, CodingKey {
    case recent = "최근 작성일 순"
    case old = "오래된 순"
    case expiration = "기간 만료 순"
}

struct HomeView: View {
    @State private var selectedButton = true
    @State private var menuStateString: MenuStateString = .recent
    @State private var menuBarState = false
    let testDocument = Document.samepleDocument
    var body: some View {
        VStack {
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
            .padding(.horizontal, 16)
            //            Spacer()
            if selectedButton {
                //                Text("아직 거래 내역이 없어요")
                //
                ZStack {
                    VStack {
                        HStack {
                            Text("총 \(testDocument.count)건")
                                .foregroundStyle(Color(hex: "#6F6F6F"))
                            Spacer()
                        }
                        .padding(.top, 17)
                        .padding(.horizontal, 16)
                        
                        List(testDocument) { document in
                            ZStack {
                                Rectangle()
                                    .frame(height: 170)
                                    .foregroundStyle(Color.boxGrayColor)
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
                                            Text(String(document.totalMoneyFormatter) + "원")
                                                .font(.system(size: 28))
                                                .bold()
                                                .padding(.top, 8)
                                            Text(document.recipient)
                                            HStack(spacing: 0) {
                                                Spacer()
                                                UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: 0, topTrailing: 0))
                                                    .frame(width: 80)
                                                    .foregroundStyle(Color.dDayCapsulColor)
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
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                menuBarState.toggle()
                            } label: {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                    .frame(width: 120, height: menuBarState ? 88 : 34)
                                    .background(Color.white)
                                    .clipShape(.rect(cornerRadius: 12))
                                    .overlay {
                                        if menuBarState == false {
                                            HStack(spacing: 4) {
                                                Text(menuStateString.stringValue)
                                                Image(systemName: "chevron.down")
                                            }
                                            .font(.system(size: 14))
                                            .foregroundStyle(.black)
                                        } else {
                                            VStack(alignment: .trailing, spacing: 10) {
                                                Button {
                                                    menuStateString = .recent
                                                    menuBarState.toggle()
                                                } label: {
                                                    HStack(spacing: 4) {
                                                        Text(MenuStateString.recent.stringValue)
                                                        Image(systemName: "chevron.down")
                                                    }
                                                }
                                                Button {
                                                    menuStateString = .old
                                                    menuBarState.toggle()
                                                } label: {
                                                    HStack(spacing: 4) {
                                                        Text(MenuStateString.old.stringValue)
                                                        Image(systemName: "chevron.down")
                                                            .foregroundStyle(Color.clear)
                                                    }
                                                }
                                                Button {
                                                    menuStateString = .expiration
                                                    menuBarState.toggle()
                                                } label: {
                                                    HStack(spacing: 4) {
                                                        Text(MenuStateString.expiration.stringValue)
                                                        Image(systemName: "chevron.down")
                                                            .foregroundStyle(Color.clear)
                                                    }
                                                }
                                            }
                                            .font(.system(size: 14))
                                            .foregroundStyle(.black)
                                        }
                                    }
                                
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 8.5)
                    .padding(.horizontal, 16)
                }
            } else {
            }
            Spacer()
        }
        .padding(.top, 30)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack {
                    Spacer().frame(height: 20)
                    Text("대진님의 기록")
                        .font(.navigationTitleSize28)
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                VStack {
                    Spacer().frame(height: 20)
                    Button {
                    }label: {
                        Image(systemName: "bell")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
