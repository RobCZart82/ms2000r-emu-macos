#pragma once

#include <cerrno>
#include <charconv>
#include <filesystem>
#include <signal.h>
#include <string_view>
#include <unistd.h>

namespace ms2k {

inline void cleanExitedEngineCopies(const std::filesystem::path& directory)
{
    std::error_code iterationError;
    for (std::filesystem::directory_iterator it(directory, iterationError), end;
         !iterationError && it != end; it.increment(iterationError)) {
        const auto name = it->path().filename().string();
        constexpr std::string_view prefix = "engine_";
        const auto separator = name.find('_', prefix.size());
        if (name.compare(0, prefix.size(), prefix) != 0 || separator == std::string::npos)
            continue;

        pid_t owner = 0;
        unsigned copy = 0;
        const char* first = name.data() + prefix.size();
        const char* split = name.data() + separator;
        const char* last = name.data() + name.size();
        const auto pidResult = std::from_chars(first, split, owner);
        const auto copyResult = std::from_chars(split + 1, last, copy);
        if (pidResult.ec != std::errc{} || pidResult.ptr != split || owner <= 0
            || copyResult.ec != std::errc{} || copyResult.ptr != last || copy == 0)
            continue;

        // An inaccessible process can still be alive. Only ESRCH confirms it is gone.
        if (::kill(owner, 0) == 0 || errno != ESRCH)
            continue;
        std::error_code fileError;
        if (std::filesystem::is_regular_file(it->symlink_status(fileError)))
            std::filesystem::remove(it->path(), fileError);
    }
}

} // namespace ms2k
