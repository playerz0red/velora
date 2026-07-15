//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 13.07.26.
//

import Foundation
import SwiftUI
import SkipKit

struct UserFormView: View {
    
    @Bindable private var viewModel: UserFormViewModel
    @Namespace private var namespace
    
    init(viewModel: UserFormViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                screenTitleView
                
                if viewModel.formModel.images.isEmpty {
                    addImageView
                } else {
                    selectedImagesListView
                        .padding(.horizontal, -15)
                }
                
                birthdayPicker
                
                sectionView(sectionTitle: "Выберите свой пол") {
                    genderPicker
                }
                
                sectionView(sectionTitle: "О себе") {
                    descriptionView
                }
                
                sectionView(sectionTitle: "Образование") {
                    educationView
                }
                
                interestsListView
                
                confirmButton
            }
            .padding(.horizontal, 15)
            .background {
                MultiPhotoPicker(isPresented: $viewModel.isShowingPhotoPicker) { imagesData in
                    viewModel.formModel.images = imagesData.map { IdentifiableData(data: $0) }
                }
            }
        }
        .background(AuthBackground())
        .animation(.bouncy, value: viewModel.formModel.images)
    }
}

private extension UserFormView {
    var screenTitleView: some View {
        Text("Анкета")
            .font(.system(size: 25, weight: .semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(Capsule().foregroundStyle(Color.lightPink))
    }
}

private extension UserFormView {
    var selectedImagesListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.formModel.images, id: \.id) { value in
                    imageView(imageData: value.data, onDelete: { viewModel.formModel.images.removeAll(where: { $0.id == value.id })})
                }
            }
        }
    }
}

private extension UserFormView {
    @ViewBuilder
    func imageView(imageData: Data, onDelete: @escaping () -> Void) -> some View {
        if let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 230)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 15))
            #if !skip
                .contentShape(Rectangle())
            #endif
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "xmark")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(7)
                        .background(Circle().foregroundStyle(Color.lightPink.opacity(0.7)))
                        .padding(15)
                        .onTapGesture(perform: onDelete)
                }
        }
    }
}

private extension UserFormView {
    var confirmButton: some View {
        Button {
            viewModel.uploadForm()
        } label: {
            Text("Сохранить")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Capsule().foregroundStyle(Color.lightPink))
        }

    }
}

private extension UserFormView {
    var interestsListView: some View {
        sectionView(sectionTitle: "Интересы") {
            CustomHStack(horizontalLimit: 300, spacing: 10) {
                ForEach(FormModel.Interest.allCases, id: \.rawValue) { interest in
                    let isSelected = viewModel.formModel.interests.contains(interest)
                    
                    interestView(interest: interest, isSelected: isSelected)
                        .onTapGesture {
                            if isSelected {
                                viewModel.formModel.interests.removeAll(where: { $0 == interest })
                            } else {
                                viewModel.formModel.interests.append(interest)
                            }
                            
                        }
                }
            }
        }
        .frame(maxWidth: CGFloat.infinity, alignment: Alignment.leading)
        .animation(Animation.bouncy, value: viewModel.formModel.interests)
    }
    
    func interestView(interest: FormModel.Interest, isSelected: Bool) -> some View {
        Text(interest.title)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(isSelected ? Color.lightPink : Color.darkGray)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background {
                Capsule()
                    .stroke(isSelected ? Color.lightPink : Color.darkGray, lineWidth: 1)
            }
    }
}

private extension UserFormView {
    var educationView: some View {
        TextField("", text: $viewModel.formModel.education, prompt: Text("Университет или колледж").font(.system(size: 18, weight: .medium)).foregroundStyle(Color.darkGray))
            .padding(10)
            .font(.system(size: 18, weight: .medium))
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.darkGray)
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.lightGray.opacity(0.5))
            }
    }
}

private extension UserFormView {
    var descriptionView: some View {
        VStack(spacing: 10) {
            TextEditor(text: $viewModel.formModel.description)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .overlay(alignment: .topLeading) {
                    if viewModel.formModel.description.isEmpty {
                        Text("Расскажите о себе что-нибудь интересное...")
                            .padding(10)
                            .allowsHitTesting(false)
                            .font(.system(size: 18, weight: .medium))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.lightGray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .animation(.spring, value: viewModel.formModel.description)
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .onChange(of: viewModel.formModel.description) { oldValue, newValue in
                    if newValue.count >= 500 {
                        viewModel.formModel.description = oldValue
                    }
                }
            
            Text("\(viewModel.formModel.description.count)/500")
                .frame(maxWidth: .infinity, alignment: .trailing)
            
        }
        .foregroundStyle(Color.darkGray)
        .font(.system(size: 18, weight: .medium))
    }
}

private extension UserFormView {
    func sectionView<Content: View>(sectionTitle: LocalizedStringResource, content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(sectionTitle)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.black)
            
            content()
        }
    }
}

private extension UserFormView {
    var birthdayPicker: some View {
        VStack(spacing: 10) {
            DatePicker("Дата рождения", selection: $viewModel.formModel.birthday, displayedComponents: .date)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.black)
#if !skip
                .datePickerStyle(.automatic)
#endif
            if viewModel.ageError {
                Text("Пользователь должен быть старше 18 лет")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.red)
                    .transition(.blurReplace.combined(with: ScaleTransition.scale))
            }
        }
        .animation(.bouncy, value: viewModel.ageError)
    }
    
    var genderPicker: some View {
        HStack(spacing: 8) {
            ForEach(FormModel.Gender.allCases, id: \.rawValue) { gender in
                genderButton(gender: gender, isSelected: gender == viewModel.formModel.gender)
                    .onTapGesture {
                        viewModel.formModel.gender = gender
                    }
            }
        }
        .padding(6)
        .background(Capsule().foregroundStyle(Color.lightGray.opacity(0.5)))
        .frame(maxWidth: .infinity)
        .animation(.bouncy, value: viewModel.formModel.gender)
    }
    
    func genderButton(gender: FormModel.Gender, isSelected: Bool) -> some View {
        Text(gender.title)
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(isSelected ? Color.white : Color.darkGray)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background {
                if isSelected {
                    Capsule()
                        .foregroundStyle(Color.lightPink)
                        #if !skip
                        .matchedGeometryEffect(id: "genderPicker", in: namespace)
                        #endif
                }
            }
    }
    
    var addImageView: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(style: StrokeStyle(
                lineWidth: 1.5,
                lineCap: .round,
                dash: [7, 7]
            ))
            .stroke(.red.gradient.opacity(0.6))
            .foregroundStyle(Color.lightGray)
            .frame(width: 200, height: 230)
            .overlay(alignment: .center) {
                Button {
                    viewModel.isShowingPhotoPicker = true
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding()
                        .background {
                            Circle()
                                .foregroundStyle(Color.lightPink)
                        }
                }

            }
    }
    
}
