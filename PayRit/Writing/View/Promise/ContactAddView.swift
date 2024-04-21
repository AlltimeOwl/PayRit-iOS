//
//  ContactAddView.swift
//  PayRit
//
//  Created by 임대진 on 4/21/24.
//

import SwiftUI
import ContactsUI

struct ContactInfo: Hashable {
    let id: String
    var firstName: String
    var givenName: String
    var phoneNumber: String
}

struct ContactAddView: View {
    @State private var contacts: [CNContact] = [CNContact]()
    @State private var isContactPickerPresented = false
    @State private var selectedContact: CNContact?
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @Binding var path: NavigationPath
    var body: some View {
        VStack(alignment: .leading) {
            Text("약속 카드 받는 사람의\n연락처를 추가해 주세요")
            .font(Font.title03)
            .padding(.bottom, 30)
            
            Form {
                Section(header: Text("받는사람").font(Font.body03).foregroundStyle(Color.gray04)) {
                    ForEach(contacts, id: \.self) { item in
                        
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundStyle(Color.gray09)
                            .frame(height: 45)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 8) {
                                    Text(item.familyName + item.givenName)
                                    
                                    Rectangle().frame(width: 1, height: 16)
                                    
                                    Text(item.phoneNumbers.first?.value.stringValue.replacingOccurrences(of: "-", with: "").phoneNumberMiddleCase() ?? "")
                                    
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
                                        phoneNumber = phoneNumber.phoneNumberMiddleCase()
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
            
            HStack {
                Spacer()
                Button {
                    if !name.isEmpty && !phoneNumber.isEmpty {
                        let newContact = CNMutableContact()
                        newContact.givenName = name
                        newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber))]
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
            
            Spacer()
            NavigationLink {
                CardInfoView(path: $path)
            } label: {
                Text("다음")
//                    .font(Font.title04)
//                    .foregroundStyle(.white)
//                    .frame(height: 50)
//                    .frame(maxWidth: .infinity)
//                    .background(!isFormValid ? Color.gray07 : Color.payritMint)
//                    .clipShape(.rect(cornerRadius: keyBoardFocused ? 0 : 12))
//                    .disabled(!isFormValid)
            }
//            .padding(.bottom, keyBoardFocused ? 0 : 16)
//            .padding(.horizontal, keyBoardFocused ? 0 : 16)
        }
        .padding(.top, 40)
        .padding(.horizontal, 16)
        .navigationTitle("약속 작성하기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture {
            self.endTextEditing()
        }
        .sheet(isPresented: $isContactPickerPresented) {
            ContactPicker(selectedContact: $selectedContact)
                .onDisappear {
                    if let item = selectedContact {
                        contacts.append(item)
                        selectedContact = nil
                    }
                }
        }
        .toolbar {
            ToolbarItem {
                Button {
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                }
            }
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
