//
//  File.swift
//  velora
//
//  Created by Pavel Playerz0redd on 14.07.26.
//

package velora

import android.net.Uri
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.PickVisualMediaRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect

@Composable
fun AndroidMultiPhotoPicker(
    isPresented: Boolean,
    onDismiss: () -> Unit,
    onResult: (List<Uri>) -> Unit
) {
    // Регистрируем системный контракт на выбор нескольких медиа-файлов
    val launcher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.PickMultipleVisualMedia(maxItems = 10) // Лимит выбора
    ) { uris ->
        onResult(uris)
        onDismiss()
    }

    LaunchedEffect(isPresented) {
        if (isPresented) {
            launcher.launch(
                PickVisualMediaRequest(ActivityResultContracts.PickVisualMedia.ImageOnly)
            )
        }
    }
}
