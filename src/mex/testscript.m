constr4 = makeConstraint('sn', '==', 20305333);
% matrix = selectDatapoints(constr4);
%v1 = getSunData('04/30/18', '04/31/18', 41.2936, -82.7233);
v2 = getWeatherData('05/11/19', '05/13/19', 42.5, -80);
%constr1 = makeConstraint('time', '>=', 1541116800);
%constr2 = makeConstraint('time', '<', 1541203200);
%v3 = selectDatapoints(andConstraint(constr1, constr2));
%constr4 = andConstraint(andConstraint(constr4, constr1), constr2)
%matrix = selectDatapoints(constr4);