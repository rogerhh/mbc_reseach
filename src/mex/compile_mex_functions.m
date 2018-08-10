mex -R2018a -lsqlite3 makeConstraint.cpp ../DataPoint.cpp ../MBCFunctions.cpp;
mex andConstraint.cpp;
mex orConstraint.cpp;
mex notConstraint.cpp;
mex -lsqlite3 selectDatapoints.cpp ../DataPoint.cpp ../MBCFunctions.cpp
%constr1 = makeConstraint('TIME', '==', '07/08/18-00:00:00');
%matrix = selectDatapoints(constr1, 'light');