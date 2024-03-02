//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct HomeView: View {
    @State private var segmentButton = true
    @State private var menuState = false
    private let menuPadding = 8.0
    private let sectionTitlePadding = 16.0
    let testDocument = Document.samepleDocument
    let homeStore = HomeStore()
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button {
                    if segmentButton { return }
                    withAnimation(.default) {
                        segmentButton.toggle()
                    }
                } label: {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 0, bottomTrailing: 0, topTrailing: 12))
                            .frame(height: 50)
                            .foregroundStyle(segmentButton ? Color.mainColor : Color.buttonCleanColor)
                        Text("빌려준 기록")
                            .foregroundStyle(segmentButton ? .black : .gray)
                    }
                }
                Button {
                    guard segmentButton else { return }
                    withAnimation(.default) {
                        segmentButton.toggle()
                    }
                } label: {
                    ZStack {
                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 0, bottomTrailing: 0, topTrailing: 12))
                            .frame(height: 50)
                            .foregroundStyle(segmentButton ? Color.buttonCleanColor : Color.mainColor)
                        Text("빌린 기록")
                            .foregroundStyle(segmentButton ? .gray : .black)
                        
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            
            if segmentButton {
                //                Text("아직 거래 내역이 없어요")
                ZStack {
                    VStack {
                        HStack {
                            Text("총 \(homeStore.document.count)건")
                                .foregroundStyle(Color(hex: "#6F6F6F"))
                            Spacer()
                        }
                        .padding(.top, sectionTitlePadding)
                        .padding(.horizontal, 16)
                        
                        List(homeStore.document) { document in
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
                                                        if document.dDay >= 0 {
                                                            Text("D - \(document.dDay)")
                                                                .foregroundStyle(.white)
                                                        } else {
                                                            Text("D + \(-document.dDay)")
                                                                .foregroundStyle(.white)
                                                        }
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
                        Spacer()
                    }
//                    .background(Color.red)
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                withAnimation {
                                    menuState.toggle()
                                }
                            } label: {
                                if menuState == false {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                        .frame(width: 120, height: menuState ? 88 : 34)
                                        .background(Color.white)
                                        .clipShape(.rect(cornerRadius: 12))
                                        .overlay {
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(homeStore.sortingType.stringValue)
                                                        .lineLimit(1)
                                                    Spacer()
                                                    Image(systemName: "chevron.down")
                                                }
                                            }
                                            .padding(.horizontal, menuPadding)
                                        }
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                        .frame(width: 120, height: menuState ? 88 : 34)
                                        .background(Color.white)
                                        .clipShape(.rect(cornerRadius: 12))
                                        .overlay {
                                            VStack(alignment: .leading, spacing: 10) {
                                                Button {
                                                    menuState.toggle()
                                                } label: {
                                                    HStack {
                                                        Text(homeStore.sortingType.stringValue)
                                                            .lineLimit(1)
                                                        Spacer()
                                                        Image(systemName: "chevron.down")
                                                    }
                                                }
                                                ForEach(SortingType.allCases, id: \.self) { state in
                                                    if state != homeStore.sortingType {
                                                        Button {
                                                            homeStore.sortingType = state
                                                            menuState.toggle()
                                                            homeStore.sortingDocument()
                                                        } label: {
                                                            HStack {
                                                                Text(state.rawValue)
                                                                Spacer()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, menuPadding)
                                        }
                                }
                            }
                        }
                        .padding(.top, sectionTitlePadding / 2)
                        Spacer()
                    }
//                    .background(Color.blue)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(hex: "767676"))
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
