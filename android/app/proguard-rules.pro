# ProGuard/R8 rules for Ant Budget (release).
#
# Picked up automatically by Flutter's Gradle plugin
# (FlutterPlugin.kt: `releaseBuildType.proguardFiles.add(proguard-rules.pro)`).

# ---------------------------------------------------------------------------
# Google ML Kit — on-device text recognition.
# ---------------------------------------------------------------------------
#
# ML Kit builds its runtime from *components* that are located reflectively:
# MlKitContext asks com.google.firebase.components.ComponentDiscovery to read
# every `@ComponentRegistrar` class name out of the AAR metadata and instantiate
# it through its no-argument constructor. R8 cannot see that reference, so in a
# minified build it deletes the registrars
#
#     com.google.mlkit.common.internal.CommonComponentRegistrar
#     com.google.mlkit.vision.common.internal.VisionCommonRegistrar
#     com.google.mlkit.vision.text.internal.TextRegistrar
#
# and then, transitively, everything only they reach — the whole recogniser
# pipeline (TextRecognition, TextRecognizer, latin.TextRecognizerOptions,
# MlKitContext, ...). The Flutter plugin still calls into it, so at runtime the
# recogniser is `null` and every scan fails with
#
#     E MethodChannel#google_mlkit_text_recognizer: Failed to handle method call
#     java.lang.NullPointerException ... on a null object reference
#
# Keeping the ML Kit packages restores the registrars and the pipeline they
# reference. (Confirmed against the R8 `usage.txt` report, which lists them as
# removed without these rules.)
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }

# The recognisers for scripts other than Latin (Chinese, Devanagari, Japanese,
# Korean) live in Maven artifacts that are only pulled in when such a script is
# requested. On this Latin-only app the classes are absent, and AGP 8+ treats a
# missing class as a hard R8 error, so tell R8 they are deliberately absent
# rather than failing the build. They are never loaded here.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
