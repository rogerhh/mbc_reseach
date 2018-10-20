constr4 = makeConstraint('temp', '<', 20);
matrix = selectDatapoints(constr4);
v1 = getSunData('03/30/18', '03/31/18', 42.2936, -83.7233);
v2 = getWeatherData('04/10/18', '05/14/18', 42, -83);
constr1 = makeConstraint('time', '>=', 1536710400);
constr2 = makeConstraint('time', '<', 1537315200);
v3 = selectDatapoints(andConstraint(constr1, constr2));