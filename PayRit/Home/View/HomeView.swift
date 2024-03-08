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
    @State private var isActionSheetPresented = false
    @State private var isNavi = false
    @State var documentInfo: Document = Document.samepleDocument[0]
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    private let homeStore = HomeStore()
    
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
                            .foregroundStyle(segmentButton ? Color.mintColor : Color.semiGrayColor4)
                        Text("빌려준 기록")
                            .foregroundStyle(segmentButton ? Color.whiteColor : Color.semiGrayColor1.opacity(0.5))
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
                            .foregroundStyle(segmentButton ? Color.semiGrayColor4 : Color.mintColor)
                        Text("빌린 기록")
                            .foregroundStyle(segmentButton ? Color.semiGrayColor1.opacity(0.5) : Color.whiteColor)
                        
                    }
                }
            }
            .bold()
            .font(.segmentTextFont16)
            .padding(.top, 16)
            .padding(.horizontal, horizontalPadding)
            
            if segmentButton {
                // 빌려준 기록
                if homeStore.document.isEmpty {
                    Text("아직 거래 내역이 없어요")
                } else {
                    ZStack {
                        VStack(spacing: 0) {
                            HStack {
                                Text("총 \(homeStore.document.count)건")
                                    .foregroundStyle(Color(hex: "#6F6F6F"))
                                    .font(Font.pretendardFont)
                                Spacer()
                            }
                            .frame(height: 34)
                            .padding(.horizontal, horizontalPadding)
                            
                            List(homeStore.document) { document in
                                Button {
                                    documentInfo = document
                                    isNavi.toggle()
                                } label: {
                                    ZStack {
                                        // MARK: 문서박스
                                        Rectangle()
                                            .frame(height: 170)
                                            .foregroundStyle(Color.boxGrayColor)
                                            .clipShape(.rect(cornerRadius: 12))
                                            .overlay {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    HStack {
                                                        Group {
                                                            Text(document.startDay)
                                                            Text("~")
                                                            Text(document.endDay)
                                                        }
                                                        .foregroundStyle(Color.semiGrayColor1)
                                                        Spacer()
                                                        Button {
                                                            isActionSheetPresented.toggle()
                                                        } label: {
                                                            Image(systemName: "ellipsis")
                                                                .foregroundStyle(Color.semiGrayColor2)
                                                                .rotationEffect(.degrees(90))
                                                                .foregroundStyle(.black)
                                                                .font(.system(size: 20))
                                                        }
                                                    }
                                                    .padding(.top, 16)
                                                    .padding(.trailing, -8)
                                                    
                                                    Text(String(document.totalMoneyFormatter) + "원")
                                                        .font(.system(size: 28))
                                                        .bold()
                                                        .padding(.top, 8)
                                                    
                                                    Text(document.recipient)
                                                        .font(.system(size: 18))
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(Color.semiGrayColor1)
                                                        .padding(.top, 8)
                                                    
                                                    Spacer()
                                                    
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 16, bottomLeading: 16, bottomTrailing: 0, topTrailing: 0))
                                                            .frame(width: 50)
                                                            .foregroundStyle(Color.dDayCapsulColor)
                                                            .overlay {
                                                                if document.dDay >= 0 {
                                                                    Text("D - \(document.dDay)")
                                                                } else {
                                                                    Text("D + \(-document.dDay)")
                                                                }
                                                            }
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 12))
                                                        
                                                        UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 16, topTrailing: 16))
                                                            .frame(width: document.state == .third ? 110 : 84)
                                                            .foregroundStyle(document.state == .third ? Color.mainColor : Color.capsulGrayColor)
                                                            .overlay {
                                                                VStack {
                                                                    Text(document.state.rawValue)
                                                                        .foregroundStyle(.white)
                                                                }
                                                            }
                                                            .font(.system(size: 14))
                                                        //                                                            Text(document.state.rawValue)
                                                        //                                                                .foregroundStyle(.white)
                                                        //                                                                .font(.system(size: 14))
                                                        //                                                                .background {
                                                        //                                                                    UnevenRoundedRectangle(cornerRadii: RectangleCornerRadii(topLeading: 0, bottomLeading: 0, bottomTrailing: 16, topTrailing: 16))
                                                        //                                                                        .frame(width: document.state == .third ? 110 : 84)
                                                        //                                                                        .foregroundStyle(document.state == .third ? Color.mainColor : Color.capsulGrayColor)
                                                        //                                                                }
                                                    }
                                                    .frame(height: 28)
                                                    .fontWeight(.semibold)
                                                    .padding(.bottom, 16)
                                                }
                                                .padding(.horizontal, horizontalPadding)
                                            }
                                        
                                    }
                                    .font(Font.pretendardFont)
                                }
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            Spacer()
                        }
                        
                        // MARK: 메뉴
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
                                                            Image(systemName: "chevron.up")
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
                            Spacer()
                        }
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.semiGrayColor2)
                        .padding(.horizontal, horizontalPadding)
                    }
                }
                
            } else {
                // 빌린 기록
                VStack {
                    Spacer()
                    Text("아직 거래 내역이 없어요")
                    Spacer()
                }
            }
            Spacer()
        }
        .padding(.top, 20)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack {
                    Spacer().frame(height: 30)
                    Text("대진님의 기록")
                        .font(.navigationTitleSize28)
                        .bold()
                        .foregroundStyle(.black)
                    Spacer().frame(height: 10)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                VStack {
                    Spacer().frame(height: 30)
                    NavigationLink {
                        Text("알림뷰")
                            .customBackbutton()
                    }label: {
                        Image(systemName: "bell")
                            .foregroundStyle(.black)
                    }
                    Spacer().frame(height: 10)
                }
            }
        }
        .confirmationDialog("", isPresented: $isActionSheetPresented, titleVisibility: .hidden) {
            Button("PDF 다운") {
            }
            Button("이메일 전송") {
            }
            Button("취소", role: .cancel) {
            }
        }
        .navigationDestination(isPresented: $isNavi) {
            LoanDetailView(document: $documentInfo)
                .customBackbutton()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
