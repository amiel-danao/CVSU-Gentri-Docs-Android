package com.cvsu_gentri_docs_android.ui.database;

import com.cvsu_gentri_docs_android.ui.common.BaseSnapshotParser;
import com.google.firebase.database.DataSnapshot;

public interface SnapshotParser<T> extends BaseSnapshotParser<DataSnapshot, T> {}
