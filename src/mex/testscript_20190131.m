constr4 = makeConstraint('sn', '==', 20305333);
% matrix = selectDatapoints(constr4);
%v1 = getSunData('04/30/18', '04/31/18', 41.2936, -82.7233);
% v2 = getWeatherData('01/10/18', '05/19/18', 30, -72);
constr1 = makeConstraint('time', '>=', 1541116800);
constr2 = makeConstraint('time', '<', 1541203200);
%v3 = selectDatapoints(andConstraint(constr1, constr2));
constr4 = andConstraint(andConstraint(constr4, constr1), constr2)
matrix = selectDatapoints(constr4);