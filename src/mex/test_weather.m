for i = 1:29
    time_start = datetime(2018,1,i,0,0,0);
    time_end   = datetime(2018,1,i+2,0,0,0);
    [time_w,cloud,solar_ele,solar_azi] = get_weather_data(time_start,time_end,135,43);
    [sunrise_time,sunset_time] = get_sun_data(time_start,time_end,142,43);
    [flag,time_s,intensity,temperature,pressure,longitude,latitude] = get_sensor_data(20418688,time_start,time_end);
    i
end