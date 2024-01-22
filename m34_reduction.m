clc 
clear


flux = [
    5252.3
    2917.9
    66461.6
    18832.3
    634.4
    654.4
    1731.9
    18861.8
    57355.7
    183414.3
    6313.2
    1046.7
    19614.9
    834.0
    7811.3
    303.8
    373.4
    2816.3
    51.3
    186969.8
    289697.9
    292287.8
    91436.3
    605.8
    6706.3
    3694.1
    5136.6
    802.3
    1136.9
    902.3
    683.6
    15260.1
    451.2
    7204.7
    2056.2
    5208.6
    5942.6
    286.4
    101029.8
    25832.8
    41276.5
    657.8
    11410.8
    326.0
    244.6
    116693.1
    8937.0
    258125.3
    57809.3
    684288.3
    20045.9
    7667.9
    254.9
    2971.0
    1478.2
    3854.5
    792.3
    24565.8
    487364.4
    7507.7
    14365.6
    ];

sortedFlux = sort(flux, 'descend'); 
highestFlux = sortedFlux(1:20);
mediumFlux = sortedFlux(21:40);
lowestFlux = sortedFlux(41:60);

signal_BFilter = [
961437.2
669465.8
410388.5
398198.5
361847.4
259800.5
259147.9
162116.7
140314.5
128620.6
81499.55
80929.02
57923.08
36374.86
34403.75
27902.33
27998.28
27659.93
26909.92
21991.18
20405.83
16171.75
12673.19
11327.76
10870.7
10914.11
10550.85
9547.408
9072.877
8618.771
7658.968
7506.837
7802.202
5542.56
5453.987
4281.922
3997.702
4174.135
3038.563
2358.221
2185.627
1581.925
1409.313
1105.216
1195.952
1125.329
1178.064
881.0332
1031.396
929.7619
800.8331
594.1147
1663.505
487.5265
319.9668
344.8094
451.6001
324.9748
    ];

signal_RFilter = [
1037155
706212.1
464958
434828.9
383939.9
288262.5
292763.4
210847.1
168113.4
155670.5
108361.9
108458.8
88078.25
59223.11
57582.84
46759.16
46440.69
47593.45
48979.83
33272.09
86389.19
33256.79
26805.78
25412.09
27479.04
41723.79
24507.97
10896.58
20133.13
19105.1
19971.19
15714.57
19448.66
13224.74
16585.05
11130.78
13703.25
13506.42
8901.448
5468.062
4919.724
9117.922
3137.194
4020.467
4612.795
3005.443
7264.204
4189.448
2218.59
3739.953
2720.1
3360.352
4912.842
2504.046
1369.968
1002.112
2017.043
933.3197
    ];

signal_VFilter = [
857371.6
591737.6
381845.4
363709.8
321073.3
239323.3
241761.3
163850
136818.5
124597.5
83922.2
84011.73
64338.82
42683.59
39802.21
33013.03
32725.29
33641.75
34227.62
24600.76
45119.61
21609.7
17123.77
16560.66
16831.37
22283.74
15619.46
13434.82
12956.83
12174.58
12375.13
10288.75
11974.42
8377.926
9632.181
6937.185
7829.902
7456.852
5208.126
3540.874
3167.392
4345.951
2043.108
2249.443
2554.978
1803.91
3432.33
2124.259
1419.211
1994.79
1645.137
1790.417
2536.1192
1267.764
763.9309
532.4228
1071.575
598.0385
    ];

for i=1:58
    instrumental_mag_b(i) = -2.5*log10(signal_BFilter(i));
end

for j=1:58
    instrumental_mag_r(j) = -2.5*log10(signal_RFilter(j));
end

for k=1:58
    instrumental_mag_v(k) = -2.5*log10(signal_VFilter(k));
end

transposed_instrumental_mag_b = instrumental_mag_b';
transposed_instrumental_mag_r = instrumental_mag_r';
transposed_instrumental_mag_v = instrumental_mag_v';

C_b = 22.86;
C_r = 22.99;
C_v = 22.79;
C = (C_b+C_r+C_v)/3; %Average of the photometric constants in all filters


apparent_mag_b = C + instrumental_mag_b
apparent_mag_r = C + instrumental_mag_r
apparent_mag_v = C + instrumental_mag_v

%Surface Brightness 

%mean flux of background in all filters (ADU's/square pixel)
flux_b = (86.9 + 85.58 + 86.52 + 85.81)/4;
flux_r = (166 + 165.1 + 164.5 + 164.3)/4;
flux_v = (145.9 + 145.6 + 145.4 + 145.1)/4;

%exposure time
exp_t_b = 5;
exp_t_r = 2.5;
exp_t_v = 2.5;

%pixel scale squared
pix_square = 0.5184;

%find flux per square arcsecond (ADU's/s/arcsec^2)
flux_per_sqarcsec_b = (flux_b/exp_t_b)/pix_square;
flux_per_sqarcsec_r = (flux_r/exp_t_r)/pix_square;
flux_per_sqarcsec_v = (flux_v/exp_t_v)/pix_square;

%calc surface brightness
mag_inst_sky_b = -2.5*log10(flux_per_sqarcsec_b);
mag_inst_sky_r = -2.5*log10(flux_per_sqarcsec_r);
mag_inst_sky_v = -2.5*log10(flux_per_sqarcsec_v);

surface_brightness_b = C_b + mag_inst_sky_b
surface_brightness_r = C_r + mag_inst_sky_r
surface_brightness_v = C_v + mag_inst_sky_v


%Graphing Diagrams

%V vs. B-V
figure(1)
plot(apparent_mag_b-apparent_mag_v,apparent_mag_v, '.','MarkerSize', 20)
set(gca, 'ydir', 'reverse')

figure(2)
plot(apparent_mag_v - apparent_mag_r, apparent_mag_v, '.','MarkerSize', 20)
set(gca, 'ydir', 'reverse')

figure(3)
plot(apparent_mag_v - apparent_mag_r, apparent_mag_b-apparent_mag_v, '.','MarkerSize', 20)
set(gca, 'ydir', 'reverse')

739, 534



