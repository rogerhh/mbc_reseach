mg_UM_Butterfly_Test_3_11_20_gmb_2_hr_test_num12.csv: from UM log mini-gateway
	w/serial # "Butterfly Test." Gateway date not set properly. Appears to
	contain a lot of irrelevant data from programming/triggers. Likely only
	relevant data is in rows 1944-1959 which should be data packets from 2-hour
	preserve test of GMB unit #12 based on original file name and packet sys id.

mg_UM_3_12_20_morning_28_14_packets.csv: from UM logo mini-gateway w/o serial #.
	Contains all data received from GMB units #28 and #14. Some data from
	packet-blasting units (used for distance test) also present.

mg_UM_3_12_20_cage_distance_28_packets.csv: from UM logo mini-gateway w/o serial #.
	Superset of mg_UM_3_12_20_morning_28_14_packets.csv. Additional packets
	at row 415 are last data transmission received before disabling #28. Note
	that gateway time was not set properly for these packets beginning at row 415.

mg_UM_Butterfly_Test_3_12_20_gmb_24hr_num14_collected_at_11_45.csv: from UM logo
	mini-gateway w/serial # "Butterfly Test." Gateway date not set properly and
	appears to contain a lot of irrelevant data from programming/triggers
	(including those in rows 246-253 which are likely early beacons from sys #5
	directly after starting program). Some data from packet-blasting distance
	test are present. Likely only useful data is in rows 913-980 from unit #14.

mg_UM_3_12_20_cage_28_packets.csv: from UM logo mini-gateway w/o serial #.
	Contains only two beacon packets from system #28 (24-hour GMB system, id=2).
	Unintended reception prior to disabling #28.




