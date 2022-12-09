package com.cvsu_gentri_docs_android.ui.auth.data.remote;

import android.app.Application;
import android.content.Intent;

import com.cvsu_gentri_docs_android.ui.auth.AuthUI;
import com.cvsu_gentri_docs_android.ui.auth.ErrorCodes;
import com.cvsu_gentri_docs_android.ui.auth.IdpResponse;
import com.cvsu_gentri_docs_android.ui.auth.data.model.Resource;
import com.cvsu_gentri_docs_android.ui.auth.data.model.UserCancellationException;
import com.cvsu_gentri_docs_android.ui.auth.ui.HelperActivityBase;
import com.cvsu_gentri_docs_android.ui.auth.ui.email.EmailActivity;
import com.cvsu_gentri_docs_android.ui.auth.viewmodel.ProviderSignInBase;
import com.cvsu_gentri_docs_android.ui.auth.viewmodel.RequestCodes;
import com.google.firebase.auth.EmailAuthCredential;
import com.google.firebase.auth.EmailAuthProvider;
import com.google.firebase.auth.FirebaseAuth;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RestrictTo;

@RestrictTo(RestrictTo.Scope.LIBRARY_GROUP)
public class EmailSignInHandler extends SingleProviderSignInHandler<Void> {
    public EmailSignInHandler(Application application) {
        super(application, EmailAuthProvider.PROVIDER_ID);
    }

    @Override
    public void startSignIn(@NonNull FirebaseAuth auth,
                            @NonNull HelperActivityBase activity,
                            @NonNull String providerId) {
        activity.startActivityForResult(
                EmailActivity.createIntent(activity, activity.getFlowParams()),
                RequestCodes.EMAIL_FLOW);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (resultCode == ErrorCodes.ANONYMOUS_UPGRADE_MERGE_CONFLICT) {
            // The activity deals with this case. This conflict is handled by the developer.
        } else if (requestCode == RequestCodes.EMAIL_FLOW) {
            IdpResponse response = IdpResponse.fromResultIntent(data);
            if (response == null) {
                setResult(Resource.forFailure(new UserCancellationException()));
            } else {
                setResult(Resource.forSuccess(response));
            }
        }
    }
}
