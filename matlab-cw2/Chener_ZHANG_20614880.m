% Chener ZHANG
% ssycz8@nottingham.edu.cn

clear all
%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

% Insert answers here
clear
a = arduino("/dev/cu.usbserial-10","Uno");
for i = 1:10  
    writeDigitalPin(a,'D7',1);  
    pause(0.5);  
    writeDigitalPin(a,'D7',0);  
    pause(0.5);  
end
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here
clear
a = arduino("/dev/cu.usbserial-10","Uno");
V_0c = 0.5;
T_c = 0.01;
duration = 600;
sampling_interval = 1;
time = 1:duration;
for t = 1:duration
    A0_voltage(t) = readVoltage(a,'A0');
    temperature(t) = (A0_voltage(t)-V_0c)/T_c;
end
min_temp = min(temperature);
max_temp = max(temperature);
avg_temp = mean(temperature);
figure;
plot(time,temperature);
xlabel('Time (s)');
xlim([0 duration]);
ylabel('Temperature (Celsius)');
grid on;

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here