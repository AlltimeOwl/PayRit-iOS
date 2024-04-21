//
//  HomeView.swift
//  PayRit
//
//  Created by 임대진 on 2/27/24.
//

import SwiftUI

enum PathType {
    case detail
    case accept
    case searching
}

struct HomePath: Hashable {
    let type: PathType
    let paperId: Int
    let step: CertificateStep
    let isWriter: Bool
}

struct HomeView: View {
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    @State private var paperId = 0
    @State private var isWriter: Bool?
    @State private var menuState = false
    @State private var isShowingSignatureView = false
    @State private var isShowingAcceptFailAlert = false
    @State private var isShowingAuthCompleteAlert = false
    @State private var isShowingPaymentSuccessAlert = false
    @State private var isShowingWaitingPaymentAlert = false
    @State private var isShowingWaitingApprovalAlert = false
    @State private var isShowingRefuseAlert = false
    @State private var isShowingDeleteAlert = false
    @State private var isShoingModifyingAlert = false
    @State private var rectangleOffset: CGSize = .zero
    @State var path = NavigationPath()
    @State var checkView: CertificateDetail?
    @Environment(HomeStore.self) var homeStore
    @Environment(SignInStore.self) var signInStore
    @Environment(TabBarStore.self) var tabStore
    @Environment(MyPageStore.self) var mypageStore
    @EnvironmentObject var iamportStore: IamportStore
    @State private var isSafariViewPresented = false
    @State private var urla: URL? = URL(string: "")
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.payritBackground.ignoresSafeArea()
                VStack {
                    if !homeStore.isHiddenInfoBox {
                        CarouselView(hasCompleted: homeStore.certificates.filter { $0.certificateStep == .complete }.isEmpty ? false : true)
                            .padding(.horizontal, 16)
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    withAnimation {
                                        homeStore.isHiddenInfoBox.toggle()
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 14, height: 14)
                                        .foregroundStyle(.white)
                                        .padding(2)
                                }
                                .padding(.trailing, 32)
                                .padding(.top, 16)
                            }
                    }
                    if homeStore.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        if !iamportStore.impAuth {
                            List {
                                VStack {
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button {
                                            iamportStore.isCert = true
                                        } label: {
                                            Text("본인인증 후 조회하기")
                                                .foregroundStyle(.black)
                                                .font(Font.body02)
                                                .opacity(0.85)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.gray08, lineWidth: 1)
                                                .background(RoundedRectangle(cornerRadius: 16)
                                                    .foregroundStyle(.white)))
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
                                                    Task {
                                                        await homeStore.loadCertificates()
                                                        switch certificate.certificateStep {
                                                        case .waitingApproval:
                                                            path.append(HomePath(type: .accept, paperId: certificate.paperId, step: .waitingApproval, isWriter: certificate.isWriter))
                                                        case .waitingPayment:
                                                            if certificate.isWriter {
                                                                path.append(HomePath(type: .accept, paperId: certificate.paperId, step: .waitingPayment, isWriter: certificate.isWriter))
                                                            } else {
                                                                isShowingWaitingPaymentAlert.toggle()
                                                            }
                                                        case .progress:
                                                            path.append(HomePath(type: .detail, paperId: certificate.paperId, step: .progress, isWriter: certificate.isWriter))
                                                        case .complete:
                                                            path.append(HomePath(type: .detail, paperId: certificate.paperId, step: .complete, isWriter: certificate.isWriter))
                                                        case .modifying:
                                                            if certificate.isWriter {
                                                                path.append(HomePath(type: .accept, paperId: certificate.paperId, step: .modifying, isWriter: certificate.isWriter))
                                                            } else {
                                                                isShoingModifyingAlert.toggle()
                                                            }
                                                        case .refused:
                                                            isShowingRefuseAlert.toggle()
                                                        case .none: break
                                                        }
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
                                                            HStack(spacing: 0) {
                                                                Text(certificate.certificateStep?.rawValue ?? "")
                                                                if certificate.certificateStep == .complete || certificate.certificateStep == .progress {
                                                                    Text(" (\(Int(certificate.repaymentRate))%)")
                                                                }
                                                            }
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
                                                    .customShadow()
                                                    
                                                }
                                                .buttonStyle(PlainButtonStyle())
                                                .listRowSeparator(.hidden)
                                                .listRowBackground(Color.payritBackground)
                                                .swipeActions {
                                                    Button {
                                                        paperId = certificate.paperId
                                                        isShowingDeleteAlert.toggle()
                                                    } label: {
                                                        Image("trashIcon")
                                                            .foregroundStyle(Color.white)
                                                    }
                                                    .tint(Color.gray06)
                                                }
                                                if certificate == homeStore.certificates.last {
                                                    Spacer().frame(height: 40)
                                                        .listRowSeparator(.hidden)
                                                }
                                            }
                                            .scrollIndicators(.hidden)
                                            .listStyle(.plain)
                                            .background(Color.payritBackground)
                                            .navigationDestination(for: HomePath.self) { path in
                                                if path.type == .accept {
                                                    CertificateAcceptView(paperId: path.paperId, isWriter: path.isWriter, certificateStep: path.step, path: $path)
                                                        .customBackbutton()
                                                        .onAppear {
                                                            tabStore.tabBarHide = true
                                                        }
                                                } else if path.type == .detail {
                                                    CertificateDetailView(paperId: path.paperId, certificateStep: path.step)
                                                        .customBackbutton()
                                                        .onAppear {
                                                            tabStore.tabBarHide = true
                                                        }
                                                } else if path.type == .searching {
                                                    CertificateSerchingView(path: $path)
                                                        .navigationBarBackButtonHidden()
                                                        .onAppear {
                                                            tabStore.tabBarHide = true
                                                        }
                                                }
                                            }
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
                                                        .shadow(color: .gray.opacity(0.2), radius: 1)
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
                                                        .shadow(color: .gray.opacity(0.2), radius: 1)
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
                    }
                    Spacer()
                    if iamportStore.isCert {
                        IMPCertificationView(certType: .constant(.account))
                            .onDisappear {
                                iamportStore.clearButton()
                            }
                    }
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
                                Button {
                                    path.append(HomePath(type: .searching, paperId: 0, step: .refused, isWriter: false))
                                } label: {
                                    Image("searchIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
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
                                    Image("alamIcon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(.black)
                                }
                                Spacer().frame(height: 10)
                            }
                        }
                    }
                }
            }
        }
        .refreshable {
            if path.isEmpty {
                tabStore.tabBarHide = false
            }
            await homeStore.loadCertificates()
        }
        .onAppear {
            tabStore.tabBarHide = false
            Task {
                await homeStore.loadCertificates()
            }
        }
        .onChange(of: homeStore.isShowingPaymentSuccessAlert) {
            isShowingPaymentSuccessAlert = homeStore.isShowingPaymentSuccessAlert
        }
        .onChange(of: homeStore.isShowingAcceptFailAlert) {
            isShowingAcceptFailAlert = homeStore.isShowingAcceptFailAlert
        }
        .onChange(of: homeStore.isShowingAuthCompleteAlert) {
            isShowingAuthCompleteAlert = homeStore.isShowingAuthCompleteAlert
        }
        .onChange(of: iamportStore.impAuth) {
            Task {
                await homeStore.loadCertificates()
            }
        }
        .onChange(of: path) {
            if path.isEmpty {
                tabStore.tabBarHide = false
            }
        }
        .primaryAlert(isPresented: $isShowingWaitingPaymentAlert, title: "결제 진행중", content: "작성자가 결제 진행중입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
            //
        } cancleAction: {
            Task {
                await homeStore.loadCertificates()
            }
        }
        .primaryAlert(isPresented: $isShoingModifyingAlert, title: "수정 진행중", content: "작성자가 수정중입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
            //
        } cancleAction: {
            Task {
                await homeStore.loadCertificates()
            }
        }
        .primaryAlert(isPresented: $isShowingPaymentSuccessAlert, title: "결제 완료", content: "페이릿 결제가 완료되었습니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingAcceptFailAlert, title: "승인 에러", content: "승인에 실패하였습니다.\n결제 대금이 취소되었습니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingAuthCompleteAlert, title: "본인인증 완료", content: "본인인증이 완료되었습니다.\n작성자의 결제 후 상세내역 조회가 가능합니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingRefuseAlert, title: "거절된 페이릿", content: "수신자가 거부한 페이릿입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShowingDeleteAlert, title: "페이릿 삭제", content: "정말 삭제하시겠습니까?\n복구할 수 없습니다.", primaryButtonTitle: "네", cancleButtonTitle: "취소") {
            homeStore.certificateHide(id: self.paperId) { result in
                if result {
                    homeStore.certificates.removeAll { $0.paperId == self.paperId }
                }
            }
        } cancleAction: {
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environment(HomeStore())
            .environment(SignInStore())
            .environment(TabBarStore())
            .environment(MyPageStore())
    }
}
