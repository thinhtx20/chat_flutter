plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services") // ✅ Plugin Google Services (Firebase)
    id("dev.flutter.flutter-gradle-plugin") // ✅ Bắt buộc để Flutter nhận dự án
}

android {
    namespace = "com.example.chat_bot_flutter"
    compileSdk = flutter.compileSdkVersion

    // ✅ Ghi đè NDK version để tương thích với firebase_auth / firebase_core
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.chat_bot_flutter"
        minSdk = 23 // ✅ Firebase yêu cầu minSdk >= 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true // ✅ Quan trọng nếu app có nhiều method (Firebase thường gây vượt giới hạn)
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // TODO: Đổi sang signingConfig của bạn khi phát hành lên store
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Bật View Binding (tùy chọn, hữu ích nếu viết UI bằng native)
    buildFeatures {
        viewBinding = true
    }

    // Tránh lỗi duplicate META-INF khi build với Firebase
    packaging {
        resources {
            excludes += setOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/license.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/notice.txt",
                "META-INF/ASL2.0"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Bổ sung nếu cần MultiDex (nên có khi minSdk >= 21)
    implementation("androidx.multidex:multidex:2.0.1")
}
