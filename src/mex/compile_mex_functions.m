mex -R2018a makeConstraint.cpp;
mex andConstraint.cpp;
mex orConstraint.cpp;
mex notConstraint.cpp;
mex -lsqlite3 selectDatapoints.cpp ../DataPoint.cpp ../MBCFunctions.cpp
constr1 = makeConstraint('SN', '>=', 11);
matrix = selectDatapoints(constr1, 11);