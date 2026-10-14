# Account data isolation

Profile, history, timer and preference boxes are namespaced by the case-sensitive Firebase UID. Guest storage has a separate namespace. Switching accounts unmounts the previous provider scope immediately and creates a fresh scope only after the new account's boxes open.

Repositories capture their account identity. History synchronization rejects guest data, another UID and a changed authentication session; an in-flight restore is discarded after sign-out. The duplicate timer-to-Firestore writer was removed so history owns session serialization.

Legacy shared boxes are retained untouched but are not automatically assigned to any account. They do not identify their original owner; automatic upload would recreate the privacy bug. Account-specific data is restored from that account's existing cloud profile. No unverified migration or data deletion is performed.

Test: `flutter test test/security/account_isolation_test.dart`. Scenarios cover A → guest → B, UID case differences, returning to A, retained legacy records, wrong-account upload, and sign-out during restore.

Production debug reward/time buttons are hidden. Local focus rewards remain self-reported productivity data, not secure paid entitlements. Existing live Firebase session-subcollection permissions are unchanged by this PR; end-to-end cloud synchronization requires a separately tested rule rollout and device validation.
