package com.cvsu_gentri_docs_android.ui.auth.viewmodel;

import android.app.Application;

import com.cvsu_gentri_docs_android.ui.auth.IdpResponse;
import com.cvsu_gentri_docs_android.ui.auth.data.model.FlowParameters;
import com.cvsu_gentri_docs_android.ui.auth.data.model.Resource;
import com.cvsu_gentri_docs_android.ui.auth.data.model.State;
import com.cvsu_gentri_docs_android.ui.auth.data.remote.AnonymousSignInHandler;
import com.cvsu_gentri_docs_android.ui.auth.testhelpers.AutoCompleteTask;
import com.cvsu_gentri_docs_android.ui.auth.testhelpers.FakeAuthResult;
import com.cvsu_gentri_docs_android.ui.auth.testhelpers.ResourceMatchers;
import com.cvsu_gentri_docs_android.ui.auth.testhelpers.TestHelper;
import com.cvsu_gentri_docs_android.ui.auth.ui.HelperActivityBase;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.robolectric.RobolectricTestRunner;

import java.util.ArrayList;

import androidx.lifecycle.Observer;
import androidx.test.core.app.ApplicationProvider;

import static com.google.common.truth.Truth.assertThat;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Unit tests for {@link AnonymousSignInHandler}.
 */
@RunWith(RobolectricTestRunner.class)
public class AnonymousSignInHandlerTest {

    @Mock
    FirebaseAuth mMockAuth;

    HelperActivityBase mMockActivity;

    @Mock
    Observer<Resource<IdpResponse>> mResponseObserver;

    AnonymousSignInHandler mHandler;

    @Before
    public void setUp() {
        TestHelper.initialize();
        MockitoAnnotations.initMocks(this);

        FlowParameters testParams = TestHelper.getFlowParameters(new ArrayList<String>());
        mMockActivity = TestHelper.getHelperActivity(testParams);

        mHandler = new AnonymousSignInHandler((Application) ApplicationProvider.getApplicationContext());
        mHandler.init(testParams);
        mHandler.mAuth = mMockAuth;
    }

    @Test
    public void testStartSignIn_expectSuccess() {
        mHandler.getOperation().observeForever(mResponseObserver);

        when(mMockAuth.signInAnonymously())
                .thenReturn(AutoCompleteTask.forSuccess(FakeAuthResult.INSTANCE));

        mHandler.startSignIn(mMockActivity);

        verify(mMockAuth).signInAnonymously();

        InOrder inOrder = inOrder(mResponseObserver);
        inOrder.verify(mResponseObserver)
                .onChanged(argThat(ResourceMatchers.isLoading()));

        ArgumentCaptor<Resource<IdpResponse>> captor = ArgumentCaptor.forClass(Resource.class);
        inOrder.verify(mResponseObserver).onChanged(captor.capture());

        assertThat(captor.getValue().getState()).isEqualTo(State.SUCCESS);
        IdpResponse response = captor.getValue().getValue();
        assertThat(response.isNewUser()).isFalse();
    }

    @Test
    public void testStartSignIn_expectFailure() {
        mHandler.getOperation().observeForever(mResponseObserver);

        when(mMockAuth.signInAnonymously())
                .thenReturn(AutoCompleteTask.forFailure(new Exception("FAILED")));

        mHandler.startSignIn(mMockActivity);

        verify(mMockAuth).signInAnonymously();

        InOrder inOrder = inOrder(mResponseObserver);
        inOrder.verify(mResponseObserver)
                .onChanged(argThat(ResourceMatchers.isLoading()));
        inOrder.verify(mResponseObserver)
                .onChanged(argThat(ResourceMatchers.isFailure()));

    }
}
