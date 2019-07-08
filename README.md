# OR-Tools Maven

This project has the goal to generate a Maven descriptors for all OR Tools Java lib and it's dependencies, including native dependencies.

The generated native jar is designed to run with the [Native-Lib-Loader](https://github.com/scijava/native-lib-loader) project. So some of the arguments must meet some conventions of this project. More on this on the `Basic Usage` Section.

## Requirements

Maven must be installed on the machine. See [Sdkman](http://sdkman.io/) for easily installation.

## Basic Usage

Run the following command to download a specified OR Tools Version, pack it's native dependencies on a JAR file and generate it's maven descriptors.

The arguments of the script are:
* URL: the url of the `tar.gz` OR Tools version. URLs can be found [here](https://github.com/google/or-tools/releases)
* Platform: the platform the native package must target, linux_64, osx_64, etc (this must follows [Native-Lib-Loader](https://github.com/scijava/native-lib-loader) conventions).
* OR Tools Version: The version to be tagged on the final artefact.
* Protobuffer Version: The protobuffer version used on this OR Tools Version. This is important cause the generated pom file will point to this version, as protobuffer is a requirement for the project.

For instance, to generate the artefact of version `7.1` for a `linux_64` machine, the following command must be executed:

```bash
./or-tools-maven https://github.com/google/or-tools/releases/download/v7.1/or-tools_debian-9_v7.1.6720.tar.gz linux_64 7.1 3.7.1
```

For `7.2` generation for a `osx_64` machine, the following command must be executed:

```bash
./or-tools-maven https://github.com/google/or-tools/releases/download/v7.2/or-tools_MacOsX-10.14.5_v7.2.6977.tar.gz osx_64 7.2 3.8.0 
```

### Using dependencies

After the artefact generation, OR Tools must be ready to be used on other projects just declaring it's dependencies on maven/gradle projects. However this package must be used with [Native-Lib-Loader](https://github.com/scijava/native-lib-loader), since it uses it's conventions to use native files in jar packages.

For instance, on a gradle file, the following dependencies must be declared:

```groovy
    implementation "org.scijava:native-lib-loader:2.3.4"
    implementation "com.google.ortools:ortools-core:7.2"
    implementation "com.google.ortools:ortools-native:7.2:linux_64"
```

Also use the `NativeLoader.loadLibrary("jniortools")`, instead of using the common `System.loadLibrary("jniortools")`.
Unfortunately this command will only load `jniortools` native lib, but none of it's dependencies. To load all OR Tools native libs, they must be declared on the ladoing phase, like:

```java
for(String lib : Arrays.asList("gflags", "glog", "protobuf",
        "CoinUtils", "Clp", "ClpSolver", "Osi", "OsiClp",
        "Cgl", "Cbc", "OsiCbc", "CbcSolver",
        "ortools", "jniortools")) {
        NativeLoader.loadLibrary(lib);
}
```

The `examples` folder shows a simple use case of the usage of this project.

After the package generation for `7.2` version, go to the `knapsack` folder and run `./gradlew run` to see it in action.
