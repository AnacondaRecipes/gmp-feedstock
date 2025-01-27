xcopy /s %RECIPE_DIR%\win_build\* .

mkdir build
cd build

cmake -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=%PREFIX%/Library -DRUN_TESTS=ON ..

:: Can't parallelize the build or else the header generation happens too late and things fail.
cmake --build . -j1
cmake --install .

:: All just import libs under different names for backwards compatibility.
copy %LIBRARY_BIN%\libgmp-%LIB_MAJOR_VERSION%.dll %LIBRARY_BIN%\libgmp.dll
copy %LIBRARY_BIN%\libgmp-%LIB_MAJOR_VERSION%.dll %LIBRARY_BIN%\gmp.dll
copy %LIBRARY_LIB%\libgmp-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\gmp.lib
copy %LIBRARY_LIB%\libgmp-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\libgmp.lib
copy %LIBRARY_LIB%\libgmp-%LIB_MAJOR_VERSION%.lib %LIBRARY_LIB%\libgmp.dll.a

copy %LIBRARY_BIN%\libgmpxx-%LIBXX_MAJOR_VERSION%.dll %LIBRARY_BIN%\libgmpxx.dll
copy %LIBRARY_BIN%\libgmpxx-%LIBXX_MAJOR_VERSION%.dll %LIBRARY_BIN%\gmpxx.dll
copy %LIBRARY_LIB%\libgmpxx-%LIBXX_MAJOR_VERSION%.lib %LIBRARY_LIB%\gmpxx.lib
copy %LIBRARY_LIB%\libgmpxx-%LIBXX_MAJOR_VERSION%.lib %LIBRARY_LIB%\libgmpxx.lib
copy %LIBRARY_LIB%\libgmpxx-%LIBXX_MAJOR_VERSION%.lib %LIBRARY_LIB%\libgmpxx.dll.a
