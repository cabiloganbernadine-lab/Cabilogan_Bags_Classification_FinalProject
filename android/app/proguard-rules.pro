-ignorewarnings

# Flutter Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# TFLite Rules
-keep class org.tensorflow.lite.** { *; }
-dontwarn org.tensorflow.lite.**

# Firebase Rules
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.internal.** { *; }
-dontwarn com.google.android.gms.internal.**

# Firestore Rules
-keep class com.google.firebase.firestore.** { *; }
-dontwarn com.google.firebase.firestore.**

# Image Picker Rules
-keep class com.baseflow.imagepicker.** { *; }

# Camera Rules
-keep class com.baseflow.camera.** { *; }
-keep class io.flutter.plugins.camera.** { *; }
