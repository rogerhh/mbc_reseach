from distutils.core import setup, Extension

# src = ['weather_data_module.cpp', 'DataPoint.cpp', 'WeatherData.cpp', 'SunriseSunsetData.cpp', 'MBCFunctions.cpp']
# module1 = Extension('spam',
#                     define_macros = [('MAJOR_VERSION', '1'),
#                                      ('MINOR_VERSION', '0')],
#                     include_dirs = ['/usr/local/include'],
#                     # libraries = ['tcl83'],
#                     library_dirs = ['/usr/local/lib', '~/python_cpp_test'],
#                     sources = ['test.cpp'])

module = Extension('weatherStation',
                   include_dirs = ['/usr/include', '/usr/include/curl'],
                   library_dirs = ['/usr/lib', '/usr/lib/x86_64-linux-gnu'],
                   extra_compile_args = ['-std=c++11 -lcurl -lsqlite3'],
                   sources = ['weather_data_module.cpp', 'DataPoint.cpp', 'WeatherData.cpp', 'SunriseSunsetData.cpp', 'MBCFunctions.cpp'])

setup (name = 'PackageName',
       version = '1.0',
       description = 'This is a test package',
       author = 'Roger Hsiao',
       author_email = 'rogerhh@umich.edu',
       ext_modules = [module])
