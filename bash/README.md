# Get the full path of the actual ls binary
readelf -d $(which ls) | grep -E "(RUNPATH|RPATH)"

# CTRL +V performs a quoted insert, inserting the next keypress as raw literal character 
