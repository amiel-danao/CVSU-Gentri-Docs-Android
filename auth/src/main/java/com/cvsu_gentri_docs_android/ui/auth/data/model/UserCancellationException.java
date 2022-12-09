package com.cvsu_gentri_docs_android.ui.auth.data.model;

import com.cvsu_gentri_docs_android.ui.auth.ErrorCodes;
import com.cvsu_gentri_docs_android.ui.auth.FirebaseUiException;

import androidx.annotation.RestrictTo;

@RestrictTo(RestrictTo.Scope.LIBRARY_GROUP)
public class UserCancellationException extends FirebaseUiException {
    public UserCancellationException() {
        super(ErrorCodes.UNKNOWN_ERROR);
    }
}
