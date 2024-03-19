//
//  CertificateSerchingView.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import SwiftUI

struct CertificateSerchingView: View {
    @State private var searchWord: String = ""
    @State private var menuState = false
    @State private var isHiddenInfoBox = false
    @State private var navigationLinkToggle = false
    @State private var index: Int = 0
    @State private var filterCount: Int = 0
    @Environment(HomeStore.self) var homeStore
    @FocusState private var interestFocused: Bool
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        Button {
                        }label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.black)
                        }
                    }
                    VStack {
                        Capsule()
                            .frame(width: UIScreen.screenWidth * 0.75, height: 40)
                            .foregroundStyle(Color.gray08)
                            .overlay {
                                TextField("", text: $searchWord)
                                    .focused($interestFocused)
                                    .font(Font.body03)
                                    .padding(.horizontal, 16)
                            }
                    }
                    VStack {
                        Button {
                            interestFocused = true
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.bottom, 10)
                ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            Text("총 \(filterCount)건")
                                .font(.custom("SUIT-Medium", size: 16))
                                .foregroundStyle(Color.gray02)
                            Spacer()
                        }
                        .frame(height: 34)
                        .padding(.horizontal, horizontalPadding)
                        
                        // MARK: - 홈 카드 리스트
                        List(homeStore.certificates, id: \.self) { certificate in
                            if certificate.peerName.contains(searchWord) {
                                Button {
    //                                self.index = index
    //                                if certificate.certificateStep == .waitingApproval {
    //                                    isShowingWaitingApprovalAlert.toggle()
    //                                } else if certificate.certificateStep == .waitingPayment {
    //                                    isShowingWaitingPaymentAlert.toggle()
    //                                } else if certificate.certificateStep == .progress {
    //                                    navigationLinkToggle.toggle()
    //                                }
                                } label: {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text("원금상환일 \(certificate.repaymentEndDate)")
                                                .font(Font.caption02)
                                                .foregroundStyle(Color.gray02)
                                            Spacer()
                                            Text(certificate.paperRole == .CREDITOR ? "빌려준 돈" : "빌린 돈")
                                                .font(Font.body03)
                                                .foregroundStyle(certificate.paperRole == .CREDITOR ? Color.payritMint : Color.payritIntensivePink)
                                        }
                                        .padding(.top, 16)
                                        
                                        Text("\(certificate.amount)원")
                                            .font(Font.title01)
                                            .padding(.top, 8)
                                        Text(certificate.peerName)
                                            .font(Font.title06)
                                            .foregroundStyle(Color.gray02)
                                            .padding(.top, 8)
                                        
                                        VStack(alignment: .trailing, spacing: 6) {
                                            HStack { Spacer() }
                                            Text(certificate.dueDate >= 0 ? "D - \(certificate.dueDate)" : "D + \(-certificate.dueDate)")
                                                .font(Font.body03)
                                                .foregroundStyle(Color.gray02)
                                            ProgressView(value: certificate.repaymentRate, total: 100)
                                                .progressViewStyle(CustomLinearProgressViewStyle(trackColor: Color.gray09, progressColor: certificate.paperRole == .CREDITOR ? Color.payritMint : Color.payritIntensivePink))
                                            Text("\(certificate.certificateStep.rawValue) (\(Int(certificate.certificateStep == .progress ? certificate.repaymentRate : 0))%)")
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
                                .padding(.bottom, index == homeStore.certificates.count - 1 ? 40 : 0)
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.payritBackground)
                            }
                        }
                        .scrollIndicators(.hidden)
                        .listStyle(.plain)
                        .background(Color.payritBackground)
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
                Spacer()
            }
        }
        .dismissOnDrag()
        .onTapGesture { self.endTextEditing() }
        .navigationDestination(isPresented: $navigationLinkToggle) {
//            if !homeStore.checkIMadeIt(homeStore.certificates[index]) && homeStore.certificates[index].state == .waitingApproval {
//                CertificateAcceptView(index: index)
//                    .customBackbutton()
//            } else {
//                CertificateDetailView(index: index)
//                    .customBackbutton()
//            }
        }
        .onChange(of: searchWord) {
            filterCount = homeStore.certificates.filter { $0.peerName.contains(searchWord) }.count
        }
        .onAppear {
            interestFocused = true
        }
    }
}

#Preview {
    NavigationStack {
        CertificateSerchingView()
            .environment(HomeStore())
    }
}
