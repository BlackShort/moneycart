package biz.moneycart.app 

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.google.android.gms.tasks.OnCompleteListener
import com.google.android.gms.tasks.Task
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.playintegrity.PlayIntegrityAppCheckProviderFactory
import android.util.Log

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val firebaseAppCheck = FirebaseAppCheck.getInstance()
        firebaseAppCheck.installAppCheckProviderFactory(
            PlayIntegrityAppCheckProviderFactory.getInstance()
        )

        firebaseAppCheck.getToken(/* forceRefresh= */ false)
            .addOnCompleteListener(OnCompleteListener { task ->
                if (task.isSuccessful) {
                    val token = task.result?.token
                    // Send the token to your server
                    Log.d("AppCheck", "App Check token: $token")
                } else {
                    Log.e("AppCheck", "Error getting App Check token", task.exception)
                }
            })
    }
}
