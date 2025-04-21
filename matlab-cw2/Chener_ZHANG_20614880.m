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
clear all
a = arduino("/dev/cu.usbserial-10","Uno");
V_0c = 0.5;
T_c = 0.01;
duration = 600;
sampling_interval = 1;
time = 0:duration;
temperature = zeros(1, length(time));
for t = 1:length(time)
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

date = datetime('now');
a = datestr(date,'dd/mm/yyyy');
Location = 'Ningbo';
b = sprintf('Data logging initiated - %s\nLocation - %s\n', a, Location);
disp(b);
for minute = 0:10
    n = minute*60+1;
    temp = temperature(n);
    c = sprintf('Minute\t\t%d',minute);
    d = sprintf('Temperature\t%.2f C\n',temp);
    disp(c);
    disp(d);
end
e = sprintf('Max temp\t%.2f C',max_temp);
f = sprintf('Min temp\t%.2f C',min_temp);
g = sprintf('Average temp\t%.2f C',avg_temp);
disp(e);
disp(f);
disp(g);
h = sprintf('\nData logging terminated');
disp(h);
fileID = fopen('cabin_temperature.txt','w');
fprintf(fileID,'Data logging initiated - %s\nLocation - %s\n\n', a, Location);
for minute = 0:10
    n = minute*60+1;
    temp = temperature(n);
    fprintf(fileID,'Minute\t\t\t%d\n',minute);
    fprintf(fileID,'Temperature\t\t%.2f C\n\n',temp);
end
fprintf(fileID,'Max temp\t\t%.2f C\n',max_temp);
fprintf(fileID,'Min temp\t\t%.2f C\n',min_temp);
fprintf(fileID,'Average temp\t%.2f C\n\n',avg_temp);
fprintf(fileID,'Data logging terminated');
fclose(fileID);
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% Insert answers here
clear all
a = arduino("/dev/cu.usbserial-10","Uno");
f = temp_monitor(a);
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here