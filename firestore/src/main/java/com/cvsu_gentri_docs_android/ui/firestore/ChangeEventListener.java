package com.cvsu_gentri_docs_android.ui.firestore;

import com.cvsu_gentri_docs_android.ui.common.BaseChangeEventListener;
import com.google.firebase.firestore.DocumentSnapshot;
import com.google.firebase.firestore.FirebaseFirestoreException;

/**
 * Listener for changes to a {@link FirestoreArray}.
 */
public interface ChangeEventListener extends
        BaseChangeEventListener<DocumentSnapshot, FirebaseFirestoreException> {}
