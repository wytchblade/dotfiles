# Get the full path of the actual ls binary
readelf -d $(which ls) | grep -E "(RUNPATH|RPATH)"
