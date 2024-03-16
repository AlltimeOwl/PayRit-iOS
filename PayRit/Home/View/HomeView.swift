//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct HomeView: View {
    @State private var index: Int = 0
    @State private var menuState = false
    @State private var isHiddenInfoBox = false
    @State private var navigationLinkToggle = false
    @State private var isShowingSignatureView = false
    @Environment(SignInStore.self) var signInStore
    @Environment(HomeStore.self) var homeStore
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isHiddenInfoBox {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color(hex: "E2FFF1"))
                        .frame(height: 190)
                        .padding(.horizontal, horizontalPadding)
                        .overlay {
                            VStack(alignment: .leading) {
                                HStack {
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            isHiddenInfoBox.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "xmark")
                                            .foregroundStyle(.black)
                                    }
                                }
                                .padding(.top, 15)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("""
                                            페이릿,
                                            기록을 시작합니다!
                                            """)
                                        .font(Font.title04)
                                        Button {
                                            print(signInStore.aToken)
                                            print(signInStore.rToken)
                                            signInStore.serverTest()
                                        } label: {
                                            Text("확인하기")
                                                .font(Font.body03)
                                                .foregroundStyle(.white)
                                        }
                                        .frame(width: 74, height: 28)
                                        .background(.black)
                                        .clipShape(.rect(cornerRadius: 19))
                                    }
                                    Spacer()
                                    Image("homeBoxImage")
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 35)
                        }
                }
                if homeStore.certificates.isEmpty {
                    Text("""
                        아직 거래내역이 없어요.
                        작성하러 가볼까요?
                        """)
                    .frame(maxHeight: .infinity)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .font(.system(size: 20))
                    .foregroundStyle(.gray).opacity(0.6)
                } else {
                    ZStack {
                        VStack(spacing: 0) {
                            HStack {
                                Text("총 \(homeStore.certificates.count)건")
                                    .font(.custom("SUIT-Medium", size: 16))
                                    .foregroundStyle(Color.gray02)
                                Spacer()
                            }
                            .frame(height: 34)
                            .padding(.horizontal, horizontalPadding)
                            
                            // MARK: - 홈 카드 리스트
                            List {
                                ForEach(homeStore.certificates.indices, id: \.self) { index in
                                    let certificate = homeStore.certificates[index]
                                    Button {
                                        self.index = index
                                        navigationLinkToggle.toggle()
                                    } label: {
                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack {
                                                Text("원금상환일 \(certificate.repaymentEndDate)")
                                                    .font(Font.caption02)
                                                    .foregroundStyle(Color.gray02)
                                                Spacer()
                                                Text(certificate.cardColor == .payritMint ? "빌려준 돈" : "빌린 돈")
                                                    .font(Font.body03)
                                                    .foregroundStyle(certificate.cardColor)
                                            }
                                            .padding(.top, 16)
                                            
                                            Text("\(certificate.totalAmountFormatter)원")
                                                .font(Font.title01)
                                                .padding(.top, 8)
                                            Text(certificate.cardColor == .payritMint ? certificate.debtorName : certificate.creditorName)
                                                .font(Font.title06)
                                                .foregroundStyle(Color.gray02)
                                                .padding(.top, 8)
                                            
                                            VStack(alignment: .trailing, spacing: 6) {
                                                HStack { Spacer() }
                                                Text(certificate.dDay >= 0 ? "D - \(certificate.dDay)" : "D + \(-certificate.dDay)")
                                                    .font(Font.body03)
                                                    .foregroundStyle(Color.gray02)
                                                ProgressView(value: certificate.state == .progress ? certificate.progressValue : 0, total: 100)
                                                    .progressViewStyle(LinearProgressViewStyle(tint: certificate.cardColor))
                                                Text("\(certificate.state.rawValue) (\(Int(certificate.state == .progress ? certificate.progressValue : 0))%)")
                                                    .font(Font.caption02)
                                                    .foregroundStyle(Color.gray04)
                                            }
                                            .padding(.bottom, 16)
                                        }
                                        .padding(.horizontal, horizontalPadding)
                                        .frame(height: 170)
                                        .frame(maxWidth: .infinity)
                                        .background()
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(color: .gray.opacity(0.2), radius: 5)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.white)
                                }
                            }
                            .listStyle(.plain)
                            Spacer()
                        }
                        
                        // MARK: - 메뉴
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
                                            .shadow(color: .gray.opacity(0.2), radius: 5)
                                            .overlay {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(homeStore.sortingType.stringValue)
                                                        Spacer()
                                                        Image(systemName: "chevron.down")
                                                    }
                                                }
                                                .padding(.horizontal, menuPadding)
                                            }
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "F2F2F2"), lineWidth: 2)
                                            .frame(width: 120, height: menuState ? 90 : 34)
                                            .background(Color.white)
                                            .clipShape(.rect(cornerRadius: 12))
                                            .shadow(color: .gray.opacity(0.2), radius: 5)
                                            .overlay {
                                                VStack(alignment: .leading, spacing: 10) {
                                                    Button {
                                                        menuState.toggle()
                                                    } label: {
                                                        HStack {
                                                            Text(homeStore.sortingType.stringValue)
                                                            Spacer()
                                                            Image(systemName: "chevron.up")
                                                        }
                                                    }
                                                    ForEach(SortingType.allCases, id: \.self) { state in
                                                        if state != homeStore.sortingType {
                                                            Button {
                                                                homeStore.sortingType = state
                                                                menuState.toggle()
                                                                homeStore.sortingCertificates()
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
                        .font(Font.body03)
                        .foregroundStyle(Color.gray02)
                        .padding(.horizontal, horizontalPadding)
                    }
                }
                Spacer()
            }
            .padding(.top, 20)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        Spacer().frame(height: 30)
                        Text("임대진님의 기록")
                            .font(Font.title01)
                            .foregroundStyle(.black)
                        Spacer().frame(height: 10)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        VStack {
                            Spacer().frame(height: 30)
                            NavigationLink {
                                CertificateSerchingView()
                                    .navigationBarBackButtonHidden()
                                    .toolbar(.hidden, for: .tabBar)
                            }label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.black)
                            }
                            Spacer().frame(height: 10)
                        }
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
            }
            .navigationDestination(isPresented: $navigationLinkToggle) {
                if !homeStore.checkIMadeIt(homeStore.certificates[index]) && homeStore.certificates[index].state == .waitingApproval {
                    CertificateAcceptView(index: index)
                        .customBackbutton()
                        .toolbar(.hidden, for: .tabBar)
                } else {
                    CertificateDetailView(index: index)
                        .customBackbutton()
                        .toolbar(.hidden, for: .tabBar)
                }
            }
            .primaryAlert(isPresented: $isShowingSignatureView, title: "본인인증", content: "본인인증 띄우기", primaryButtonTitle: "예", cancleButtonTitle: "아니오") {
                //
            } cancleAction: {
                //
            }
        }
        .onAppear {
            if !signInStore.currenUser.signature {
                isShowingSignatureView.toggle()
            }
            homeStore.sortingCertificates()
//            if let new = homeStore.checkNewReceived() {
//                
//            }
        }

    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(SignInStore())
            .environment(HomeStore())
    }
}
