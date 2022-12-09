package com.cvsu_gentri_docs_android.ui.database;

import com.cvsu_gentri_docs_android.ui.common.BaseChangeEventListener;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;

/**
 * Listener for changes to {@link FirebaseArray}.
 */
public interface ChangeEventListener extends BaseChangeEventListener<DataSnapshot, DatabaseError> {}
