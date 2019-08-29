mex -R2018a -lsqlite3 -lcurl makeConstraint.cpp ../json11.cpp ../DataPoint.cpp ../SunriseSunsetData.cpp ../WeatherData.cpp ../MBCFunctions.cpp;
mex andConstraint.cpp;
mex orConstraint.cpp;
mex notConstraint.cpp;
mex -lsqlite3 -lcurl selectDatapoints.cpp ../json11.cpp ../DataPoint.cpp ../SunriseSunsetData.cpp ../WeatherData.cpp ../MBCFunctions.cpp
mex -lsqlite3 -lcurl getSunData.cpp ../json11.cpp ../DataPoint.cpp ../SunriseSunsetData.cpp  ../WeatherData.cpp ../MBCFunctions.cpp
mex -lsqlite3 -lcurl getWeatherData.cpp ../json11.cpp ../DataPoint.cpp ../SunriseSunsetData.cpp ../WeatherData.cpp ../MBCFunctions.cpp