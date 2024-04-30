//
//  CertificateSerchingView.swift
//  PayRit
//
//  Created by 임대진 on 3/13/24.
//

import SwiftUI

struct CertificateSerchingView: View {
    private let menuPadding = 8.0
    private let horizontalPadding = 16.0
    @State var isPromiseDeleted: Int = 0
    @State private var searchWord: String = ""
    @State private var filterPayritCount: Int = 0
    @State private var filterPromiseCount: Int = 0
    @State private var segment: HomeSegment = .payrit
    @State private var menuState = false
    @State private var isShowingSignatureView = false
    @State private var isShowingWaitingApprovalAlert = false
    @State private var isShowingWaitingPaymentAlert = false
    @State private var isShowingRefuseAlert = false
    @State private var isShoingModifyingAlert = false
    @State var certificateStep: CertificateStep?
    @Binding var promises: [Promise]
    @Binding var path: NavigationPath
    @Environment(HomeStore.self) var homeStore
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @FocusState private var interestFocused: Bool
    
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                HStack {
                    VStack {
                        Button {
                            self.presentationMode.wrappedValue.dismiss()
                        }label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.black)
                        }
                    }
                    VStack {
                        Capsule()
                            .stroke(Color.payritMint, lineWidth: 1)
                            .background(Color.gray08)
                            .clipShape(.capsule)
                            .frame(width: UIScreen.screenWidth * 0.75, height: 40)
                            .overlay {
                                TextField("검색어를 입력해 주세요", text: $searchWord)
                                    .focused($interestFocused)
                                    .font(Font.body03)
                                    .padding(.horizontal, 16)
                            }
                    }
                    VStack {
                        Button {
                            interestFocused = true
                        } label: {
                            Image("searchIcon")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.black)
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                HStack(spacing: 26) {
                    Button {
                        withAnimation(.smooth) {
                            segment = .payrit
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text("페이릿").foregroundStyle(segment == .payrit ? Color.payritMint : Color.gray06)
                            Rectangle().frame(width: 48, height: 3).foregroundStyle(segment == .payrit ? Color.payritMint : Color.clear)
                        }
                    }
                    Button {
                        withAnimation(.smooth) {
                            segment = .promise
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text("약속").foregroundStyle(segment == .promise ? Color.payritMint : Color.gray06)
                            Rectangle().frame(width: 32, height: 3).foregroundStyle(segment == .promise ? Color.payritMint : Color.clear)                            }
                    }
                    Spacer()
                }
                .foregroundStyle(Color.payritMint)
                .font(.custom("SUIT-Bold", size: 18))
                .padding(.top, 8)
                .padding(.horizontal, 18)
                
                switch segment {
                case .payrit:
                    ZStack {
                        VStack(spacing: 0) {
                            HStack {
                                Text("검색결과 총 \(filterPayritCount)건")
                                    .font(.custom("SUIT-Medium", size: 16))
                                    .foregroundStyle(Color.gray02)
                                Spacer()
                            }
                            .frame(height: 34)
                            .padding(.horizontal, horizontalPadding + 2)
                            
                            // MARK: - 홈 카드 리스트
                            ScrollViewReader { _ in
                                List(homeStore.certificates, id: \.self) { certificate in
                                    if certificate.peerName.contains(searchWord) || String(certificate.amount).contains(searchWord) {
                                        Button {
                                            switch certificate.certificateStep {
                                            case .waitingApproval:
                                                path.append(PayritPath(type: .accept, paperId: certificate.paperId, step: .waitingApproval, isWriter: certificate.isWriter))
                                            case .waitingPayment:
                                                if certificate.isWriter {
                                                    path.append(PayritPath(type: .accept, paperId: certificate.paperId, step: .waitingPayment, isWriter: certificate.isWriter))
                                                } else {
                                                    isShowingWaitingPaymentAlert.toggle()
                                                }
                                            case .progress:
                                                path.append(PayritPath(type: .payritDetail, paperId: certificate.paperId, step: .progress, isWriter: certificate.isWriter))
                                            case .complete:
                                                path.append(PayritPath(type: .payritDetail, paperId: certificate.paperId, step: .complete, isWriter: certificate.isWriter))
                                            case .modifying:
                                                if certificate.isWriter {
                                                    path.append(PayritPath(type: .accept, paperId: certificate.paperId, step: .modifying, isWriter: certificate.isWriter))
                                                } else {
                                                    isShoingModifyingAlert.toggle()
                                                }
                                            case .refused:
                                                isShowingRefuseAlert.toggle()
                                            case .none: break
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
                                            .customShadow()
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.payritBackground)
                                        .padding(.bottom, certificate == homeStore.certificates.last ? 40 : 0)
                                    }
                                }
                                .scrollIndicators(.hidden)
                                .listStyle(.plain)
                                .background(Color.payritBackground)
                            }
                            Spacer()
                        }
                        
                        // MARK: - 메뉴
                        if filterPayritCount > 0 {
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
                case .promise:
                    VStack(spacing: 0) {
                        HStack {
                            Text("검색결과 총 \(filterPromiseCount)건")
                                .font(.custom("SUIT-Medium", size: 16))
                                .foregroundStyle(Color.gray02)
                            Spacer()
                        }
                        .frame(height: 34)
                        .padding(.horizontal, horizontalPadding + 2)
                        
                        ScrollView {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                ForEach($promises, id: \.self) { $promise in
                                    if promise.writerName.contains(searchWord) || String(promise.amount).contains(searchWord) {
                                        Button {
                                            promise.isClicked.toggle()
                                        } label: {
                                            Image(promise.promiseImageType.rawValue)
                                                .resizable()
                                                .clipShape(.rect(cornerRadius: 12))
                                                .scaledToFit()
                                                .overlay {
                                                    if promise.isClicked {
                                                        GeometryReader { reader in
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .stroke(Color.gray08, lineWidth: 1)
                                                                .fill(Color.white)
                                                                .opacity(0.7)
                                                                .frame(width: reader.size.width, height: reader.size.height)
                                                        }
                                                    }
                                                }
                                        }
                                        .overlay {
                                            if promise.isClicked {
                                                ZStack {
                                                    VStack(alignment: .leading) {
                                                        if promise.participants.count > 1 {
                                                            Text("\(promise.writerName)님과\n\(promise.participants[0].participantsName)님 외 \(promise.participants.count - 1)명의 약속")
                                                                .lineSpacing(4)
                                                        } else {
                                                            Text("\(promise.writerName)님과\n\(promise.participants[0].participantsName)님의 약속")
                                                                .lineSpacing(4)
                                                        }
                                                        Spacer()
                                                        HStack {
                                                            Text("\(promise.amount)원")
                                                                .font(Font.title03)
                                                            Spacer()
                                                        }
                                                    }
                                                    .font(Font.body01)
                                                    .padding(.vertical, 18)
                                                    .padding(.horizontal, 14)
                                                    
                                                    Spacer()
                                                    NavigationLink {
                                                        PromiseDetailView(detail: promise, isDelete: $isPromiseDeleted)
                                                            .customBackbutton()
                                                            .onDisappear {
                                                                if isPromiseDeleted != 0 {
                                                                    promises.removeAll { $0.promiseId == isPromiseDeleted }
                                                                    isPromiseDeleted = 0
                                                                }
                                                            }
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 30)
                                                            .stroke(Color.gray07, lineWidth: 1)
                                                            .fill(Color(hex: "F9F9F9"))
                                                            .frame(width: 105, height: 30)
                                                            .overlay {
                                                                Text("내용 보기")
                                                                    .font(Font.caption01)
                                                                    .foregroundStyle(Color.black)
                                                            }
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding()
                            .padding(.bottom, 40)
                        }
                        .scrollIndicators(.hidden)
                    }
                }
                Spacer()
            }
        }
        .dismissOnDrag()
        .onTapGesture {
            self.endTextEditing()
        }
        .onChange(of: searchWord) {
            if Int(searchWord) ?? 0 >= 0 {
                filterPayritCount = homeStore.certificates.filter { String($0.amount).contains(searchWord) }.count
                filterPromiseCount = promises.filter { String($0.amount).contains(searchWord) }.count
            } else {
                filterPayritCount = homeStore.certificates.filter { $0.peerName.contains(searchWord) }.count
                filterPromiseCount = promises.filter { $0.writerName.contains(searchWord) }.count
            }
        }
        .onAppear {
            interestFocused = true
        }
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
        .primaryAlert(isPresented: $isShowingRefuseAlert, title: "거절된 페이릿", content: "수신자가 거부한 페이릿입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
        } cancleAction: {
        }
        .primaryAlert(isPresented: $isShoingModifyingAlert, title: "수정 진행중", content: "작성자가 수정중입니다.", primaryButtonTitle: nil, cancleButtonTitle: "확인") {
            //
        } cancleAction: {
            Task {
                await homeStore.loadCertificates()
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        CertificateSerchingView(path: .constant(NavigationPath()), promises: Binding<[Promise]>)
//            .environment(HomeStore())
//    }
//}
