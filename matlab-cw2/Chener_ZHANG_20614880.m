% Chener ZHANG
% ssycz8@nottingham.edu.cn

clear all
%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

% Insert answers here
clear
a = arduino("/dev/cu.usbserial-10","Uno"); % connect the arduino to the workspace 
for i = 1:10 % set 10 cycles
    writeDigitalPin(a,'D7',1);  % connect the LED to the digital pin (e.g. D7) and make it light
    pause(0.5);  % keep the LED light on for 0.5 seconds
    writeDigitalPin(a,'D7',0);  % turn off the LED
    pause(0.5); % keep the LED light off for 0.5 seconds
end
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here
clear all
a = arduino("/dev/cu.usbserial-10","Uno"); % connect the arduino to the workspace 
V_0c = 0.5; % the zero degree voltage of the temperature seneor is 0.5 V
T_c = 0.01; % the temperature coefficient of the temperature sensor is 0.01
duration = 600; % set the run time as 600 seconds
interval = 1; % set the sampling interval as 1 s
time = 0:duration; % create the array of time from 0 to the end of duration
temperature = zeros(1, length(time)); % initialize the temperature array
for t = 1:length(time) % set the cycle for several times (equal to the length of time array)
    A0_voltage(t) = readVoltage(a,'A0'); % record the voltage of the temperature sensor which is connect to the analogue pin (A0)
    temperature(t) = (A0_voltage(t)-V_0c)/T_c; % calculate the temperature based on the voltage
    pause(0.95); % the actual time for 1 cycle only consume 0.05 s, pause 0.95 to reach the real interval
end
min_temp = min(temperature); % record the minimum temperature
max_temp = max(temperature); % record the maximum temperature
avg_temp = mean(temperature); % record the average temperature
figure; % start drawing the figure
plot(time,temperature); % plot the time and temperature figure
xlabel('Time (s)'); % the label for x axis is Time unit is s
xlim([0 600]); % the x axis is from 0 to 600
ylabel('Temperature (Celsius)'); % the label for y axis is temperature the unit is celsius
grid on; % generate grid lines

date = datetime('now'); % dectect and record the actual time
a = datestr(date,'mm/dd/yyyy'); % set the date format as month/date/year (e.g.05/03/2025)
Location = 'Ningbo'; 
b = sprintf('Data logging initiated - %s\nLocation - %s\n', a, Location); % set the format of heading of the table
disp(b); % display the heading of table in the command window
for minute = 0:10 % since the duation in 600s, the duration in minutes is 10 min. set a cycle for 10 times (1 min/time)
    n = minute*60+1; % since the time start from 0 and there are 601 data in time array, to avoid the n is 0, plus 1
    temp = temperature(n); % record the temperature
    c = sprintf('Minute\t\t%d',minute); % set the time format (for alignment use two tab)
    d = sprintf('Temperature\t%.2f C\n',temp); % set the temperature format (two decimal places)
    disp(c); % display the time in command window
    disp(d); % display the temperature in command window
end
e = sprintf('Max temp\t%.2f C',max_temp); % set the temperature format (two decimal places)
f = sprintf('Min temp\t%.2f C',min_temp); % set the temperature format (two decimal places)
g = sprintf('Average temp\t%.2f C',avg_temp);% set the temperature format (two decimal places)
disp(e);  % display the temperature in command window
disp(f);  % display the temperature in command window
disp(g);  % display the temperature in command window
h = sprintf('\nData logging terminated');
disp(h);
fileID = fopen('cabin_temperature.txt','w'); % open the file called cabin_temperature.txt, set the file ID and let the computer write data to the file.
%if there is already a file with this file ID, cover it
fprintf(fileID,'Data logging initiated - %s\nLocation - %s\n\n', a, Location); % write the heading of the table into the file
% write the minute and temperature values in specific format to the file
% similar to the above process
for minute = 0:10
    n = minute*60+1;
    temp = temperature(n);
    fprintf(fileID,'Minute\t\t\t%d\n',minute);
    fprintf(fileID,'Temperature\t\t%.2f C\n\n',temp);
end
% write the minimum, maximum and average temperature values in specific format to the file
% similar to the above process
fprintf(fileID,'Max temp\t\t%.2f C\n',max_temp);
fprintf(fileID,'Min temp\t\t%.2f C\n',min_temp);
fprintf(fileID,'Average temp\t\t%.2f C\n\n',avg_temp);
fprintf(fileID,'Data logging terminated');
fclose(fileID); % close the file
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% Insert answers here
clear all
a = arduino("/dev/cu.usbserial-10","Uno"); % connect the arduino to the workspace 
f = temp_monitor(a); % call function of temp_monitor to the main file and pass the variable a which represents the arduino
% use "doc temp_monitor" in command window to see the documentation of the function
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]
% Insert answers here
clear all
a = arduino("/dev/cu.usbserial-10","Uno"); % connect the arduino to the workspace 
f = temp_prediction(a); % call function of temp_prediction to the main file and pass the variable a which represents the arduino
% use "doc temp_prediction" in command window to see the documentation of the function
%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here
% This coursework focused on designing a real-time temperature monitoring system using Arduino and MATLAB to monitor whether the temperature of a cabin is comfortable and stable. One of the most significant challenges was establishing reliable communication between MATLAB and the Arduino. At first, my USA to USB data cable had some connection problem, and when connecting the Arduino, it was always time consuming. Another problem is that the connecting problem between breadboard and LEDs for example, in the early stage, due to poor contact of the jumper or incorrect resistance value, the LED failed to light up normally or burned out. Meanwhile, the challenge of task 2 was monitoring the discontinuity of the graph in real time, which meant that the though the temperature can be monitored infinitely, after the image had continuously displayed 30 data points, the first 30 data lines would disappear when the 31st data point began to be drawn, and then the sixtieth data point was drawn and this cycle repeated. For task 3, the challenge was that the noise of the temperature sensor would lead to inaccurate rate of temperature change. Sensor noise caused sharp fluctuations in temperature data, resulting in unstable predicted values in the initial stage. In this coursework, I have learnt to use the hardware and add-on app of the MATLAB. Meanwhile, I have learnt how to use Git hub to store and update the files. Also, the experience of the creation of function file can help to the future project. Meanwhile, some new instructions like ‘drawnow’, ‘tic and toc’ have been learnt. There are also some limitations of the project, e.g, the stability of the temperature and the living figure. To improve the project, noise can be suppressed by adding a temperature compensation algorithm and hardware shielding.