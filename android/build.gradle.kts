allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        val extension = project.extensions.findByName("android")
        if (extension is com.android.build.gradle.BaseExtension) {
            // Fix: older plugins like tflite_v2 don't have a namespace
            try {
                if (extension.namespace == null) {
                    extension.namespace = "com.example.${project.name.replace("-", "_")}"
                }
            } catch (e: Exception) {
                // Property might not exist on older AGP versions
            }
            
            extension.compileSdkVersion(35)
            extension.defaultConfig {
                targetSdkVersion(35)
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
