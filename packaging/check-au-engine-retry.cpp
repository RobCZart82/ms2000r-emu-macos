#include <AudioToolbox/AudioToolbox.h>
#include <dlfcn.h>
#include <filesystem>
#include <iostream>

// Run against a disposable copy of the bundle. No component registration or ROMs are needed.
int main(int argc, char** argv)
{
    if (argc != 2)
        return 2;

    const std::filesystem::path bundle(argv[1]);
    const auto engine = bundle / "Contents/Resources/MS2000R_engine";
    const auto parked = bundle / "Contents/Resources/engine-parked";
    auto* module = dlopen((bundle / "Contents/MacOS/MS2000R").c_str(), RTLD_NOW | RTLD_LOCAL);
    if (!module) {
        std::cerr << dlerror() << '\n';
        return 1;
    }
    const auto factory = reinterpret_cast<AudioComponentFactoryFunction>(
        dlsym(module, "MS2000RAUFactory"));
    if (!factory) {
        std::cerr << "MS2000RAUFactory missing\n";
        return 1;
    }

    const AudioComponentDescription description{
        kAudioUnitType_MusicDevice, 'Ms2r', 'Msem', 0, 0
    };
    std::filesystem::rename(engine, parked);
    const bool openedWithoutEngine = factory(&description) != nullptr;
    std::filesystem::rename(parked, engine);
    const bool recovered = factory(&description) != nullptr;
    if (!recovered || openedWithoutEngine) {
        std::cerr << "Expected a failed load followed by successful recovery\n";
        return 1;
    }
    // This short-lived process only checks the factory; it does not open an AU instance.
    std::cout << "AU factory recovered after the engine was restored\n";
}
