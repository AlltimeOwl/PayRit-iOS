//
//  WritingCertificateInfoView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingCertificateInfoView: View {
    let certificateType: String
    let writingStore: WritingStore = WritingStore()
    @State private var repaymentStartDate: Date = Date()
    @State private var repaymentEndDate: Date = Date()
    @State private var money: String = ""
    @State private var interestRate: String = ""
    @State private var interestDate: String = ""
    @State private var specialConditions: String = ""
    @State private var onTapBorrowedDate: Bool = false
    @State private var onTapRedemptionDate: Bool = false
    @State private var warningMessage: Bool = false
    @State private var calToggle: Bool = false
    @State private var isShowingStopAlert: Bool = false
    @State private var isShowingInterestToastMessage: Bool = false
    @State private var isShowingInterestWarningToastMessage: Bool = false
    @State private var isShowingFormToastMessage: Bool = false
    @State private var isShowingBorrowedDatePicker: Bool = false
    @State private var isShowingRedemptionDatePicker: Bool = false
    @State private var isShowingNotYetService: Bool = false
    @State private var moveNextView: Bool = false
    @State private var keyBoardFocused: Bool = false
    @State private var newCertificate: CertificateDetail = CertificateDetail.EmptyCertificate
    @Binding var path: NavigationPath
    @Environment(MyPageStore.self) var mypageStore
    @FocusState var interestTextFieldFocus: Bool
    @Namespace var bottomID
    var isFormValid: Bool {
        if calToggle {
            return !money.isEmpty && onTapBorrowedDate && onTapRedemptionDate && !interestRate.isEmpty
        } else {
            return !money.isEmpty && onTapBorrowedDate && onTapRedemptionDate
        }
    }
    var body: some View {
        ZStack {
            Color.payritBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            Text(certificateType == "CREDITOR" ? "빌려주기로 한 돈의\n정보를 입력해 주세요." : "빌리기로 한 돈의\n정보를 입력해 주세요")
                                .font(Font.title03)
                            VStack(alignment: .leading) {
                                Text(certificateType == "CREDITOR" ? "얼마를 빌려주기로 했나요?" : "얼마를 빌리기로 했나요?")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money)
                                    .onChange(of: money) { _, _ in
                                        if let money = Int(money) {
                                            if money <= 30000000 {
                                                newCertificate.paperFormInfo.primeAmount = money
                                            } else {
                                                self.money = "30000000"
                                                newCertificate.paperFormInfo.primeAmount = 30000000
                                                isShowingNotYetService = true
                                            }
                                        }
                                    }
                                if isShowingNotYetService {
                                    Text("서비스 이용금액은 최대 3천만원 입니다.")
                                        .font(Font.caption01)
                                        .foregroundStyle(Color.payritErrorRed)
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(certificateType == "CREDITOR" ? "언제 빌려주기로 했나요?" : "언제 빌리기로 했나요?")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray08, lineWidth: 1)
                                    .fill(Color.gray09)
                                    .background(RoundedRectangle(cornerRadius: 6))
                                    .foregroundStyle(.white)
                                    .frame(height: 45)
                                    .overlay(
                                        VStack {
                                            Button {
                                                endTextEditing()
                                                onTapBorrowedDate = true
                                                isShowingBorrowedDatePicker.toggle()
                                            } label: {
                                                HStack {
                                                    if onTapBorrowedDate {
                                                        Text(repaymentStartDate.hyphenFomatter())
                                                            .font(Font.body02)
                                                            .foregroundStyle(.black)
                                                    } else {
                                                        Text("YY.MM.DD")
                                                            .font(Font.body02)
                                                            .foregroundStyle(Color.gray07)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "calendar")
                                                        .font(.system(size: 20))
                                                        .foregroundStyle(Color.gray06)
                                                }
                                            }
                                        }
                                            .padding(.horizontal, 14)
                                        , alignment: .leading
                                    )
                            }
                            
                            VStack(alignment: .leading) {
                                Text("언제까지 갚기로 했나요?")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray08, lineWidth: 1)
                                    .fill(Color.gray09)
                                    .background(RoundedRectangle(cornerRadius: 6))
                                    .foregroundStyle(.white)
                                    .frame(height: 45)
                                    .overlay(
                                        VStack {
                                            Button {
                                                endTextEditing()
                                                onTapRedemptionDate = true
                                                isShowingRedemptionDatePicker.toggle()
                                            } label: {
                                                HStack {
                                                    if onTapRedemptionDate {
                                                        Text(repaymentEndDate.hyphenFomatter())
                                                            .font(Font.body02)
                                                            .foregroundStyle(.black)
                                                    } else {
                                                        Text("YY.MM.DD")
                                                            .font(Font.body02)
                                                            .foregroundStyle(Color.gray07)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "calendar")
                                                        .font(.system(size: 20))
                                                        .foregroundStyle(Color.gray06)
                                                }
                                            }
                                        }
                                            .padding(.horizontal, 14)
                                        , alignment: .leading
                                    )
                            }
                            
                            VStack(alignment: .leading) {
                                Text("특별히 추가할 내용이 있나요? (선택)")
                                    .font(Font.body03)
                                    .foregroundStyle(Color.gray04)
                                CustomTextField(foregroundStyle: .black, placeholder: "특별히 추가할 내용을 적어주세요", keyboardType: .default, text: $specialConditions)
                                    .onChange(of: specialConditions) {
                                        newCertificate.paperFormInfo.specialConditions = specialConditions
                                    }
                            }
                            VStack(spacing: 0) {
                                if !calToggle {
                                    HStack {
                                        Text("이자 계산")
                                            .font(.system(size: 16))
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Toggle("", isOn: $calToggle)
                                            .onTapGesture {
                                                interestTextFieldFocus = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                    withAnimation {
                                                        proxy.scrollTo(bottomID, anchor: .top)
                                                    }
                                                }
                                            }
                                            .tint(Color.payritMint)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.payritMint, lineWidth: 2)
                                            .background(Color(hex: "E5FDFC"))
                                    )
                                } else {
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text("이자 계산")
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                            Spacer()
                                            Toggle("", isOn: $calToggle)
                                                .onTapGesture {
                                                    interestRate = ""
                                                    interestDate = ""
                                                    newCertificate.paperFormInfo.interestPaymentDate = 0
                                                }
                                                .tint(Color.payritMint)
                                        }
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(
                                            Rectangle()
                                                .foregroundStyle(Color(hex: "E5FDFC"))
                                        )
                                        VStack(alignment: .leading, spacing: 0) {
                                            HStack(spacing: 2) {
                                                Text("연 이자율")
                                                Button {
                                                    isShowingInterestToastMessage.toggle()
                                                } label: {
                                                    Image(systemName: "questionmark.circle")
                                                }
                                            }
                                            .font(Font.body03)
                                            .foregroundStyle(Color.gray04)
                                            .padding(.top, 4)
                                            
                                            CustomTextField(placeholder: "이자율을 입력해주세요", keyboardType: .decimalPad, text: $interestRate, isFocused: interestTextFieldFocus)
                                                .onChange(of: interestRate) { oldValue, newValue in
                                                    if newValue.count < 6 {
                                                        if newValue.filter({ $0 == "." }).count >= 2 {
                                                            interestRate = oldValue
                                                        } else {
                                                            if !interestRate.isEmpty && interestRate != "." {
                                                                if Float(newValue) ?? 20.0 >= 20.0 {
                                                                    interestRate = "19.99"
                                                                    warningMessage = true
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        interestRate = oldValue
                                                    }
                                                    newCertificate.paperFormInfo.interestRate = Float(interestRate) ?? 0.0
                                                }
                                                .onTapGesture {
                                                    withAnimation {
                                                        proxy.scrollTo(bottomID, anchor: .top)
                                                    }
                                                }
                                                .padding(.top, 4)
                                            
                                            if warningMessage {
                                                HStack {
                                                    Text("이자는 20%를 넘어설 수 없어요.")
                                                    Button {
                                                        isShowingInterestWarningToastMessage.toggle()
                                                    } label: {
                                                        Image(systemName: "questionmark.circle")
                                                    }
                                                }
                                                .font(Font.caption01)
                                                .foregroundStyle(Color.payritErrorRed)
                                                .padding(.top, 4)
                                            }
                                            
                                            HStack(spacing: 0) {
                                                Text("지급해야하는 이자는 약 ")
                                                Text("\(newCertificate.paperFormInfo.interestRateAmount)")
                                                    .foregroundStyle(Color.payritMint)
                                                Text("원이에요")
                                            }
                                            .padding(.vertical, 20)
                                            .font(Font.body02)
                                            
                                            Text("이자 지급일(선택)")
                                                .font(Font.body03)
                                                .foregroundStyle(Color.gray04)
                                            
                                            CustomTextField(placeholder: "예) 매달 3일이면 3을 입력해주세요", keyboardType: .numberPad, text: $interestDate)
                                                .onChange(of: interestDate) { _, newValue in
                                                    if Int(newValue) ?? 31 > 31 {
                                                        interestDate = "31"
                                                    }
                                                    newCertificate.paperFormInfo.interestPaymentDate = Int(interestDate) ?? 0
                                                }
                                                .onTapGesture {
                                                    withAnimation {
                                                        proxy.scrollTo(bottomID, anchor: .top)
                                                    }
                                                }
                                                .padding(.top, 4)
                                        }
                                        .padding(16)
                                    }
                                    .id(bottomID)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.payritMint, lineWidth: 2)
                                    )
                                }
                            }
                            
                            if !money.isEmpty {
                                HStack(spacing: 0) {
                                    Text("총 ")
                                    if calToggle {
                                        Text("\(newCertificate.paperFormInfo.totalAmountFormatter)")
                                            .foregroundStyle(Color.payritMint)
                                    } else {
                                        Text(newCertificate.paperFormInfo.primeAmountFomatter)
                                            .foregroundStyle(Color.payritMint)
                                    }
                                    Text("원을 상환해야해요!")
                                }
                                .font(Font.title04)
                            }
                        }
                        .padding(.top, 30)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                }
                Button {
                    if !isFormValid {
                        isShowingFormToastMessage.toggle()
                    } else {
                        moveNextView.toggle()
                    }
                } label: {
                    Text("다음")
                        .font(Font.title04)
                        .foregroundStyle(.white)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(!isFormValid ? Color.gray07 : Color.payritMint)
                        .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
                }
                .padding(.bottom, keyBoardFocused ? 0 : 16)
                .padding(.horizontal, keyBoardFocused ? 0 : 16)
            }
        }
        .dismissOnDrag()
        .scrollIndicators(.hidden)
        .navigationTitle("페이릿 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { self.endTextEditing() }
        .onChange(of: keyBoardFocused) {
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
        }
        .toolbar {
            ToolbarItem {
                Button {
                    isShowingStopAlert.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
        }
        .sheet(isPresented: $isShowingBorrowedDatePicker, content: {
            DatePicker("", selection: $repaymentStartDate, in: Date()..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                    newCertificate.paperFormInfo.repaymentStartDate = repaymentStartDate.hyphenFomatter()
                    repaymentEndDate = repaymentStartDate
                }
        })
        .sheet(isPresented: $isShowingRedemptionDatePicker, content: {
            DatePicker("", selection: $repaymentEndDate, in: repaymentStartDate..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                    newCertificate.paperFormInfo.repaymentEndDate = repaymentEndDate.hyphenFomatter()
                }
        })
        .onChange(of: repaymentStartDate) {
            newCertificate.paperFormInfo.repaymentStartDate = repaymentStartDate.hyphenFomatter()
        }
        .onChange(of: repaymentEndDate) {
            newCertificate.paperFormInfo.repaymentEndDate = repaymentEndDate.hyphenFomatter()
        }
        .primaryAlert(isPresented: $isShowingStopAlert,
                      title: "작성 중단",
                      content: """
                        지금 작성을 중단하시면
                        처음부터 다시 작성해야해요.
                        작성 전 페이지로 돌아갈까요?
                        """,
                      primaryButtonTitle: "아니오",
                      cancleButtonTitle: "네") {
        } cancleAction: {
            path = .init()
        }
        .toast(isShowing: $isShowingInterestWarningToastMessage, title: nil, message: "이자제한법상 법정 최고 이자율은 20% 미만 입니다.")
        .toast(isShowing: $isShowingInterestToastMessage, title: "빌려준 날짜부터 갚는 날짜까지의 일수를 기준으로 계산됩니다.", message: "예) 원금이 50만원, 이자율이 2%, 일수가 300일 일때\n50만원 * 2% * 300/365 = 약 8,219원")
        .toast(isShowing: $isShowingFormToastMessage, title: nil, message: "필수 항목을 작성해주세요")
        .navigationDestination(isPresented: $moveNextView) {
            MyInfoWritingView(writingStore: writingStore, newCertificate: $newCertificate, path: $path)
                .customBackbutton()
        }
        .onAppear {
            newCertificate.memberRole = certificateType
            mypageStore.loadCertInfo()
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            WritingCertificateInfoView(certificateType: "DEBTOR", path: .constant(NavigationPath()))
                .environment(TabBarStore())
                .environment(MyPageStore())
        }
    }
}
