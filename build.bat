echo "NOTE: `libffi-lake` doesn't fully support windows and hasn't been tested on it"

if not exist "lib\ffi.lib" (
    echo "Missing libffi's ""lib\ffi.lib"""
)
if not exist "include\ffi.h" (
    echo "Missing libffi's ""include\ffi.h"""
)
