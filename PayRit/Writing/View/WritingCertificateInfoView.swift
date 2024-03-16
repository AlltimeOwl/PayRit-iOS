//
//  WritingCertificateInfoView.swift
//  PayRit
//
//  Created by 임대진 on 2/29/24.
//

import SwiftUI

struct WritingCertificateInfoView: View {
    @State private var borrowedDate: Date = Date()
    @State private var redemptionDate: Date = Date()
    @State private var money: String = ""
    @State private var etc: String = ""
    @State private var interest: String = ""
    @State private var interestDate: String = ""
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
    @State private var moveNextView: Bool = false
    @State private var keyBoardFocused: Bool = false
    @State private var newCertificate: Certificate = Certificate.EmptyCertificate
    @Binding var certificateType: WriterRole
    @Binding var path: NavigationPath
    @FocusState var interestTextFieldFocus: Bool
    @Namespace var bottomID
    var isFormValid: Bool {
        if calToggle {
            return !money.isEmpty && onTapBorrowedDate && !interest.isEmpty
        } else {
            return !money.isEmpty && onTapBorrowedDate
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("얼마를 빌려주기로 했나요?")
                                .font(Font.body03)
                                .foregroundStyle(Color.gray04)
                            CustomTextField(placeholder: "금액을 입력해주세요", keyboardType: .numberPad, text: $money)
                                .onChange(of: money) {
                                    newCertificate.money = Int(money) ?? 0
                                }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("언제 빌려주기로 했나요?")
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
                                                    Text(borrowedDate.dateToString())
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
                                                    Text(redemptionDate.dateToString())
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
                            CustomTextField(foregroundStyle: .black, placeholder: "특별히 추가할 내용을 적어주세요", keyboardType: .default, text: $etc)
                                .onChange(of: etc) {
                                    newCertificate.etc? = etc
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
                                                interest = ""
                                                interestDate = ""
                                                newCertificate.interestRateDay = nil
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
                                        
                                        CustomTextField(placeholder: "숫자를 입력해주세요", keyboardType: .decimalPad, text: $interest, isFocused: interestTextFieldFocus)
                                            .onChange(of: interest) { oldValue, newValue in
                                                if newValue.count < 6 {
                                                    if newValue.filter({ $0 == "." }).count >= 2 {
                                                        interest = oldValue
                                                    } else {
                                                        if !interest.isEmpty && interest != "." {
                                                            if Float(newValue) ?? 20.0 >= 20.0 {
                                                                interest = "19.99"
                                                                warningMessage = true
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    interest = oldValue
                                                }
                                                newCertificate.interestRate = Double(interest) ?? 0.0
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
                                            Text("\(newCertificate.interestRateAmount)")
                                                .foregroundStyle(Color.payritMint)
                                            Text("원이에요")
                                        }
                                        .padding(.vertical, 20)
                                        .font(Font.body02)
                                        
                                        Text("이자 지급일(선택)")
                                            .font(Font.body03)
                                            .foregroundStyle(Color.gray04)
                                        CustomTextField(placeholder: "숫자를 입력해주세요", keyboardType: .numberPad, text: $interestDate)
                                            .onChange(of: interestDate) { _, _ in
                                                newCertificate.interestRateDay = interestDate
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
                                    Text("\(newCertificate.totalAmountFormatter)")
                                        .foregroundStyle(Color.payritMint)
                                } else {
                                    Text(newCertificate.totalMoneyFormatter)
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
            DatePicker("", selection: $borrowedDate, displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                    newCertificate.repaymentStartDate = borrowedDate.dateToString()
                }
        })
        .sheet(isPresented: $isShowingRedemptionDatePicker, content: {
            DatePicker("", selection: $redemptionDate, in: borrowedDate..., displayedComponents: [.date])
                .datePickerStyle(.graphical)
                .presentationDetents([.height(400)])
                .onDisappear {
                    newCertificate.repaymentStartDate = borrowedDate.dateToString()
                }
        })
        .onChange(of: borrowedDate) {
            newCertificate.repaymentStartDate = borrowedDate.dateToString()
        }
        .onChange(of: redemptionDate) {
            newCertificate.repaymentEndDate = redemptionDate.dateToString()
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
            MyInfoWritingView(newCertificate: $newCertificate, path: $path)
                .customBackbutton()
        }
        .onAppear {
            newCertificate.WriterRole = certificateType
        }
    }
}

#Preview {
    TabView {
        NavigationStack {
            WritingCertificateInfoView(certificateType: .constant(.DEBTOR), path: .constant(NavigationPath()))
        }
    }
}
