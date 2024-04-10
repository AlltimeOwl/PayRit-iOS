//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

struct HomeView: View {
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    @State private var paperId = 0
    @State private var menuState = false
    @State private var isHiddenInfoBox = false
    @State private var isShowingSignatureView = false
    @State private var isShowingWaitingApprovalAlert = false
    @State private var isShowingWaitingPaymentAlert = false
    @State private var navigationLinkDetailView = false
    @State private var navigationLinkAcceptView = false
    @State var certificateStep: CertificateStep?
    @Environment(HomeStore.self) var homeStore
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack {
                if !isHiddenInfoBox {
                    CarouselView()
                        .padding(.horizontal, 16)
                }
                if homeStore.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    if homeStore.certificates.isEmpty {
                        ZStack {
                            List {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Text("""
                                아직 거래내역이 없어요.
                                작성하러 가볼까요?
                                """)
                                        .frame(maxHeight: .infinity)
                                        .multilineTextAlignment(.center)
                                        .lineSpacing(4)
                                        .font(.system(size: 20))
                                        .foregroundStyle(.gray).opacity(0.6)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .frame(height: UIScreen.screenHeight * 0.5)
                                .listRowSeparator(.hidden)
                            }
                            .listStyle(.plain)
                            .listSectionSeparator(.hidden)
                            .scrollIndicators(.hidden)
                            VStack(spacing: -4) {
                                Spacer()
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 190, height: 44)
                                    .overlay {
                                        Text("차용증·약속 작성하러 가기")
                                            .foregroundStyle(.white)
                                            .font(.custom("SUIT-Bold", size: 14))
                                    }
                                Image(systemName: "arrowtriangle.down.fill")
                            }
                            .foregroundStyle(Color.gray04)
                            .padding(.bottom, 50)
                        }
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
                                ScrollViewReader { _ in
                                    List(homeStore.certificates, id: \.self) { certificate in
                                        Button {
                                            certificateStep = certificate.certificateStep
                                            paperId = certificate.paperId
                                            if certificate.certificateStep == .waitingApproval {
                                                if certificate.isWriter {
                                                    isShowingWaitingApprovalAlert.toggle()
                                                } else {
                                                    navigationLinkAcceptView.toggle()
                                                }
                                            } else if certificate.certificateStep == .waitingPayment {
                                                if certificate.isWriter {
                                                    navigationLinkAcceptView.toggle()
                                                } else {
                                                    isShowingWaitingPaymentAlert.toggle()
                                                }
                                            } else if certificate.certificateStep == .progress {
                                                navigationLinkDetailView.toggle()
                                            } else if certificate.certificateStep == .complete {
                                                navigationLinkDetailView.toggle()
                                            }
                                        } label: {
                                            VStack(alignment: .leading, spacing: 0) {
                                                HStack {
                                                    Text("원금상환일   \(certificate.repaymentEndDate.stringDateToKorea())")
                                                        .font(Font.caption01)
                                                    Spacer()
                                                    Text(certificate.dueDate >= 0 ? "D - \(certificate.dueDate)" : "D + \(-certificate.dueDate)")
                                                        .font(Font.custom("SUIT-Bold", size: 14))
                                                }
                                                .foregroundStyle(.white)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 10)
                                                .background(certificate.paperRole == .CREDITOR ? Color.payritMint : Color.payritIntensivePink)
                                                .clipShape(.rect(cornerRadius: 8))
                                                .padding(.top, 14)
                                                
                                                Text("\(certificate.amountFormatter)원")
                                                    .font(Font.title01)
                                                    .padding(.top, 22)
                                                
                                                VStack(alignment: .trailing, spacing: 0) {
                                                    HStack {
                                                        Text(certificate.peerName)
                                                            .font(Font.title06)
                                                            .foregroundStyle(.black)
                                                        Spacer()
                                                        Text(certificate.paperRole == .CREDITOR ? "빌려준 돈" : "빌린 돈")
                                                            .font(Font.body03)
                                                            .foregroundStyle(certificate.paperRole == .CREDITOR ? Color.payritMint : Color.payritIntensivePink)
                                                    }
                                                    
                                                    ProgressView(value: certificate.repaymentRate, total: 100)
                                                        .progressViewStyle(CustomLinearProgressViewStyle(trackColor: Color.gray09, progressColor: certificate.paperRole == .CREDITOR ? Color.payritMint : Color.payritIntensivePink))
                                                        .frame(height: 6)
                                                        .padding(.top, 14)
                                                    
                                                    Text("\(certificate.certificateStep?.rawValue ?? "") (\(Int(certificate.repaymentRate))%)")
                                                        .font(Font.caption02)
                                                        .foregroundStyle(Color.gray04)
                                                        .padding(.top, 4)
                                                        .padding(.bottom, 14)
                                                }
                                                .padding(.top, 4)
                                            }
                                            .padding(.horizontal, horizontalPadding)
                                            .frame(maxWidth: .infinity)
                                            .background()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(color: .gray.opacity(0.2), radius: 5)
                                        }
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.payritBackground)
                                        .padding(.bottom, certificate == homeStore.certificates.last ? 40 : 0)
                                    }
                                    .scrollIndicators(.hidden)
                                    .listStyle(.plain)
                                    .background(Color.payritBackground)
                                }
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
                }
                Spacer()
            }
            .padding(.top, 40)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack {
                        Spacer().frame(height: 30)
                        if UserDefaultsManager().getUserInfo().signInCompany == "애플" {
                            Text("\(UserDefaultsManager().getAppleUserInfo().name)님의 기록")
                                .font(Font.title01)
                                .foregroundStyle(.black)
                        } else {
                            Text("\(UserDefaultsManager().getUserInfo().name)님의 기록")
                                .font(Font.title01)
                                .foregroundStyle(.black)
                        }
                        Spacer().frame(height: 10)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        VStack {
                            Spacer().frame(height: 30)
                            NavigationLink {
//                                CertificateSerchingView()
//                                    .navigationBarBackButtonHidden()
//                                    .onAppear {
//                                        tabStore.tabBarHide = true
//                                    }
                            }label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.black)
                            }
                            Spacer().frame(height: 10)
                        }
                        VStack {
                            Spacer().frame(height: 30)
                            NavigationLink {
                                NotificationView()
                                    .customBackbutton()
                                    .onAppear {
                                        tabStore.tabBarHide = true
                                    }
                            }label: {
                                Image(systemName: "bell")
                                    .foregroundStyle(.black)
                            }
                            Spacer().frame(height: 10)
                        }
                    }
                }
            }
        }
        .navigationDestination(isPresented: $navigationLinkDetailView) {
            if !homeStore.certificates.isEmpty {
                if let setp = certificateStep {
                    CertificateDetailView(paperId: paperId, certificateStep: setp)
                        .customBackbutton()
                        .onAppear {
                            tabStore.tabBarHide = true
                        }
                }
            }
        }
        .navigationDestination(isPresented: $navigationLinkAcceptView) {
            if !homeStore.certificates.isEmpty {
                if let setp = certificateStep {
                    CertificateAcceptView(paperId: paperId, certificateStep: setp)
                        .customBackbutton()
                        .onAppear {
                            tabStore.tabBarHide = true
                        }
                }
            }
        }
        .refreshable {
            await homeStore.loadCertificates()
        }
        .onAppear {
            tabStore.tabBarHide = false
            Task {
                await homeStore.loadCertificates()
            }
        }
        //        .primaryAlert(isPresented: $isShowingSignatureView, title: "본인인증", content: "본인인증 띄우기", primaryButtonTitle: "예", cancleButtonTitle: "아니오") {
        //            //
        //        } cancleAction: {
        //            //
        //        }
        .primaryAlert(isPresented: $isShowingWaitingApprovalAlert, title: "승인 요청", content: "아직 상대방이 승인하지 않았습니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
            //
        } cancleAction: {
            //
        }
        .primaryAlert(isPresented: $isShowingWaitingPaymentAlert, title: "결제 진행중", content: "작성자가 결제 진행중입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
            //
        } cancleAction: {
            //
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(HomeStore())
            .environment(SignInStore())
            .environment(TabBarStore())
    }
}
