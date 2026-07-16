//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 14.07.26.
//

import SwiftUI

#if !skip
import PhotosUI
#else
import skip.ui // Нужно для ComposeView
import android.net.Uri
#endif

struct MultiPhotoPicker: View {
    @Binding var isPresented: Bool
    var onPhotosSelected: ([Data]) -> Void
    
    var body: some View {
        #if !skip
        // --- РЕАЛИЗАЦИЯ ДЛЯ IOS ---
        iOSPickerView(isPresented: $isPresented, onPhotosSelected: onPhotosSelected)
        #else
        // --- РЕАЛИЗАЦИЯ ДЛЯ ANDROID ---
        AndroidPickerView(isPresented: $isPresented, onPhotosSelected: onPhotosSelected)
        #endif
    }
}

// MARK: - iOS Реализация
#if !skip
private struct iOSPickerView: View {
    @Binding var isPresented: Bool
    var onPhotosSelected: ([Data]) -> Void
    @State private var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        Color.clear
            .photosPicker(
                isPresented: $isPresented,
                selection: $selectedItems,
                maxSelectionCount: 10,
                matching: .images
            )
            .onChange(of: selectedItems) { oldValue, newItems in
                if newItems.count < oldValue.count { return }
                
                Task {
                    print(newItems.count)
                    var dataArray: [Data] = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            dataArray.append(data)
                        }
                    }
                    onPhotosSelected(dataArray)
                    selectedItems = [] // Сбрасываем выбор
                }
            }
    }
}
#endif

// MARK: - Android Реализация
#if skip
private struct AndroidPickerView: View {
    @Binding var isPresented: Bool
    var onPhotosSelected: ([Data]) -> Void
    
    var body: some View {
        if isPresented {
            // Внедряем Compose-код в SwiftUI дерево
            ComposeView { context in
                velora.AndroidMultiPhotoPicker(
                    isPresented: isPresented,
                    onDismiss: { isPresented = false },
                    onResult: { uris in
                        var dataArray: [Data] = []
                        for uri in uris {
                            // Skip умеет читать данные из URI через привычную Data(contentsOf:)
                            if let url = URL(string: uri.toString()),
                               let data = try? Data(contentsOf: url) {
                                dataArray.append(data)
                            }
                        }
                        onPhotosSelected(dataArray)
                        isPresented = false
                    }
                )
            }
        }
    }
}
#endif
