# TensorFlow Lite GPU Delegate
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.task.core.** { *; }


# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options$GpuBackend
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options