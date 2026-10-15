# ProGuard/R8 rules for Ant Budget (release).
#
# Picked up automatically by Flutter's Gradle plugin
# (FlutterPlugin.kt: `releaseBuildType.proguardFiles.add(proguard-rules.pro)`).
#
# google_mlkit_text_recognition's `TextRecognizer.initialize` references the
# recognisers for scripts other than Latin (Chinese, Devanagari, Japanese,
# Korean). Their Maven artifacts are only pulled in when a non-Latin script is
# actually requested, so on the default Latin-only app the classes are absent.
# AGP 8+ treats a missing class as a hard R8 error, so we tell R8 these are
# deliberately absent rather than failing the build. They are never loaded
# here because the app never asks for those scripts.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
