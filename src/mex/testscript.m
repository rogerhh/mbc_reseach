constr4 = makeConstraint('temp', '<', 20);
matrix = selectDatapoints(constr4);
v1 = getSunData('05/03/18', '05/04/18', 42, -83);
v2 = getWeatherData('05/03/18', '05/04/18', 42, -83);