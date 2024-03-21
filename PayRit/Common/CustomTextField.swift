//
//  CustomTextField.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

// MARK: 커스텀 텍스트필드
// 플레이스홀더(힌트메세지), 키보드타입, 텍스트를 선언해줄 수 있다.
// 키보드타입은 default가 기본으로, 특정 타입이 있다면 슈퍼뷰에서 넘겨준다.
// 자동대문자화 false, 자동 수정 false 처리

@available(iOS 17.0, *)
public struct CustomTextField: View {
    var maxLength: Int = 100
    var backgroundColor: Color = .white
    var foregroundStyle: Color = .black
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    public init(maxLength: Int = 100, backgroundColor: Color = Color.gray09, foregroundStyle: Color = .black, placeholder: String, keyboardType: UIKeyboardType = .default, text: Binding<String>, isFocused: Bool = false) {
        self.maxLength = maxLength
        self.backgroundColor = backgroundColor
        self.foregroundStyle = foregroundStyle
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self._text = text
        self.isFocused = isFocused
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray08, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(backgroundColor))
            TextField("", text: $text, prompt: Text(placeholder).font(Font.body02).foregroundColor(Color.gray07))
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                .font(Font.body02)
                .foregroundStyle(foregroundStyle)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if isFocused {
                HStack {
                    Spacer()
                    Button(action: {
                        text = ""
                    }, label: {
                        Image(systemName: "xmark.circle")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.gray06)
                    })
                    .padding(.trailing, 14)
                }
            }
        }
        .frame(height: 45)
        .onChange(of: text) { oldValue, newValue in
            if newValue.count > maxLength {
                text = String(newValue.prefix(maxLength))
                isFocused = false
            }
            _ = oldValue
        }
    }
}

@available(iOS 15.0, *)
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            CustomTextField(placeholder: "숫자를 입력해주세요", text: .constant(""))
                .padding()
        }
    }
}
