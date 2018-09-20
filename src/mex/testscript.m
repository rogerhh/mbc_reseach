constr4 = makeConstraint('temp', '<', 20);
matrix = selectDatapoints(constr4);
v1 = getSunData('05/09/18', '06/04/18', 42, -83);
v3 = getWeatherData('04/10/18', '05/14/18', 20, -83);