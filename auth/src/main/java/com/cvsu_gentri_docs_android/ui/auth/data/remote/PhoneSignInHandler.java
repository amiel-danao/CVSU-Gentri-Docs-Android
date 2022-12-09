package com.cvsu_gentri_docs_android.ui.auth.data.remote;

import android.app.Application;
import android.content.Intent;

import com.cvsu_gentri_docs_android.ui.auth.AuthUI;
import com.cvsu_gentri_docs_android.ui.auth.IdpResponse;
import com.cvsu_gentri_docs_android.ui.auth.data.model.Resource;
import com.cvsu_gentri_docs_android.ui.auth.data.model.UserCancellationException;
import com.cvsu_gentri_docs_android.ui.auth.ui.HelperActivityBase;
import com.cvsu_gentri_docs_android.ui.auth.ui.phone.PhoneActivity;
import com.cvsu_gentri_docs_android.ui.auth.viewmodel.ProviderSignInBase;
import com.cvsu_gentri_docs_android.ui.auth.viewmodel.RequestCodes;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.PhoneAuthProvider;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

@RestrictTo(RestrictTo.Scope.LIBRARY_GROUP)
public class PhoneSignInHandler extends SingleProviderSignInHandler<AuthUI.IdpConfig> {
    public PhoneSignInHandler(Application application) {
        super(application, PhoneAuthProvider.PROVIDER_ID);
    }

    @Override
    public void startSignIn(@NonNull FirebaseAuth auth,
                            @NonNull HelperActivityBase activity,
                            @NonNull String providerId) {
        activity.startActivityForResult(
                PhoneActivity.createIntent(
                        activity, activity.getFlowParams(), getArguments().getParams()),
                RequestCodes.PHONE_FLOW);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == RequestCodes.PHONE_FLOW) {
            IdpResponse response = IdpResponse.fromResultIntent(data);
            if (response == null) {
                setResult(Resource.forFailure(new UserCancellationException()));
            } else {
                setResult(Resource.forSuccess(response));
            }
        }
    }
}
