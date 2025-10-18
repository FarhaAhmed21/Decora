plugins {
    id("com.android.application")
    id("kotlin-android")
    // FlutterFire Configuration
    id("com.google.gms.google-services")
    // لازم يكون بعد Android و Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.decora"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.decora"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Import Firebase BoM (manages versions automatically)
    implementation(platform("com.google.firebase:firebase-bom:34.3.0"))

    // Firebase core products
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")

    // Needed for Firebase Auth (Google Sign-In)
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
