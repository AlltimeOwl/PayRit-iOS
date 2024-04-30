//
//  ContactAddView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI
import ContactsUI

struct Contacts: Hashable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var phoneNumber: String
}

struct ContactAddView: View {
    @State var promise: Promise = Promise(promiseId: 0, amount: 0, promiseStartDate: Date(), promiseEndDate: Date(), writerName: "", contents: "", participants: [Participants](), promiseImageType: .PRESENT)
    @State private var contacts: [Contacts] = [Contacts]()
    @State private var selectedContact: CNContact?
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var isContactPickerPresented = false
    @State private var isShowingStopAlert = false
    @State private var keyBoardFocused: Bool = false
    @Binding var path: NavigationPath
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    Text("약속 카드 받는 사람의\n연락처를 추가해 주세요")
                        .font(Font.title03)
                    Text("직접 추가하거나 주소록을 불러올 수 있습니다.")
                        .font(Font.body02)
                        .foregroundStyle(Color.gray07)
                    HStack { Spacer() }
                }
                .padding(.top, 40)
                
                Form {
                    Section(header: Text("보낸 사람").font(Font.body03).foregroundStyle(Color.gray04)) {
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color.gray09)
                            .frame(height: 45)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 8) {
                                    TextField(text: $promise.writerName) {
                                        Text("이름")
                                            .foregroundStyle(Color.gray07)
                                    }
                                }
                                .font(Font.body02)
                                .padding(.horizontal, 14)
                            }
                    }
                    
                    Section(header: Text("받는 사람").font(Font.body03).foregroundStyle(Color.gray04).padding(.top, 24)) {
                        ForEach(contacts) { item in
                            
                            RoundedRectangle(cornerRadius: 6)
                                .foregroundStyle(Color.gray09)
                                .frame(height: 45)
                                .overlay(alignment: .leading) {
                                    HStack(spacing: 8) {
                                        Text(item.name)
                                        
                                        Rectangle().frame(width: 1, height: 16)
                                        
                                        Text(item.phoneNumber)
                                        
                                        Spacer()
                                        
                                        Button {
                                            contacts.removeAll { $0 == item }
                                        } label: {
                                            Image(systemName: "xmark.circle")
                                                .font(.system(size: 20))
                                                .foregroundStyle(Color.gray06)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .font(Font.body02)
                                    .padding(.horizontal, 14)
                                }
                        }
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color.gray09)
                            .frame(height: 45)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 8) {
                                    TextField(text: $name) {
                                        Text("이름")
                                            .foregroundStyle(Color.gray07)
                                    }
                                    .frame(width: 50)
                                    
                                    Rectangle().frame(width: 1, height: 16)
                                        .foregroundStyle(Color.gray07)
                                    
                                    TextField(text: $phoneNumber) {
                                        Text("연락처")
                                            .foregroundStyle(Color.gray07)
                                    }
                                    .keyboardType(.numberPad)
                                    .onChange(of: phoneNumber) { oldValue, newValue in
                                        if newValue.count <= 13 {
                                            phoneNumber = phoneNumber.hyphen()
                                        } else {
                                            phoneNumber = oldValue
                                        }
                                    }
                                    Spacer()
                                }
                                .font(Font.body02)
                                .padding(.horizontal, 14)
                            }
                    }
                }
                .formStyle(.columns)
                .padding(.top, 30)
                
                HStack {
                    Spacer()
                    Button {
                        if !name.isEmpty && !phoneNumber.isEmpty {
                            let newContact = Contacts(name: name, phoneNumber: phoneNumber)
                            contacts.append(newContact)
                            name = ""
                            phoneNumber = ""
                        } else {
                            isContactPickerPresented.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 25))
                            .tint(Color.payritMint)
                    }
                    Spacer()
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, 16)
            
            NavigationLink {
                CardInfoView(contacts: contacts, promise: $promise, path: $path)
                    .customBackbutton()
            } label: {
                Text("다음")
                    .font(Font.title04)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(contacts.isEmpty || promise.writerName.isEmpty ? Color.gray07 : Color.payritMint)
                    .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
            }
            .padding(.bottom, keyBoardFocused ? 0 : 16)
            .padding(.horizontal, keyBoardFocused ? 0 : 16)
            .disabled(contacts.isEmpty || promise.writerName.isEmpty)
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationTitle("약속 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isContactPickerPresented) {
            ContactPicker(selectedContact: $selectedContact)
                .onDisappear {
                    if let item = selectedContact {
                        let newContact = Contacts(name: item.familyName + item.givenName, phoneNumber: item.phoneNumbers.first?.value.stringValue.replacingOccurrences(of: "-", with: "").hyphen() ?? "")
                        contacts.append(newContact)
                        selectedContact = nil
                    }
                }
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
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { _ in
            keyBoardFocused = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyBoardFocused = false
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
    }
}

#Preview {
    ContactAddView(path: .constant(NavigationPath()))
}

struct ContactPicker: UIViewControllerRepresentable {
    @Binding var selectedContact: CNContact?

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = context.coordinator
        return contactPicker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedContact: $selectedContact)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        @Binding var selectedContact: CNContact?

        init(selectedContact: Binding<CNContact?>) {
            _selectedContact = selectedContact
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            selectedContact = contact
        }
    }
}
