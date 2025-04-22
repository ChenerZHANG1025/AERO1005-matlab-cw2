function temp_monitor = temp_monitor(a)
% TEMP_MONITOR is a function based on the temperature collected by the
% temperature sensor which is connected to arduino and pass the information
% by using the arduino and is used to monitor the temperature of the cabin.
%
% TEMP_MONITOR = TEMP_MONITOR(a) is worked with the variable a, which
% represents the arduino connected to the computer. (e.g.a =
% arduino("/dev/cu.usbserial-10","Uno")), the connected arduino should set
% in the main running file and pass the arduino variable to the function
% here. The function is to monitor the temperature of the cabin. It is used to
% draw the living figure for the temperature changing with the time and
% the temperature by using LED to make the temperature representation more
% direct. If the Green LED lights on, the cabin is in a comfortable
% temperature (18-24 °C), when the temperature is greater, the red LED turns
% on, and the yellow one turn on when the temperature is lower than 18 °C.

% draw the living time-temperature figure 
figure;
h = plot(NaN,NaN); % set a variable represents an empty figure
% set the label for x and y axes
xlabel('Time (s)');
ylabel('Temperature (Celsius)');
grid on; % generate the grid lines
xlim([0 30]) % limit the initial x axis from 0 to 30
ylim([10 40]); % limit the y axis from 10 t0 40
hold on; % keep the figure drawing

n = 30;  % set 30 data points for each group of data
time_data = NaN(1, n); % set an empty array with the length of the whole duration for collecting time data
temp_data = NaN(1, n); % set an empty array with the length of the whole duration for collecting temperature data
idx = 1; % let the data collect from number 1, and make an index for the data collected from the arduino


% Make the LED  ccxdcxlight off at the beginning
writeDigitalPin(a, 'D3', 0); % D3 connects with green LED
writeDigitalPin(a, 'D5', 0); % D5 connects with yellow LED
writeDigitalPin(a, 'D7', 0); % D7 connects with red LED

tic; % start the timer
while true % set infinite time for the loop
    time = toc; % set the variable 'time' as the time required to run the code
    A0_voltage = readVoltage(a, 'A0'); % record the voltage of the temperature sensor which is connect to the analogue pin (A0)
    temp = (A0_voltage - 0.5) / 0.01;  % calculate the temperature based on the voltage
    % set the limit of the x axis to adapt the change of the time
    % when time larger than 30 s, change the limitation of the x axis from the 30 s before the current time  
   if time > 30
        x_lim_min = time - 30;
        x_lim_max = time;
        xlim([x_lim_min x_lim_max]) 
   end
    time_data(idx) = time; % store the current time to the time array
    temp_data(idx) = temp; % store the current temperature to the temperature array
    set(h, 'XData', time_data(1:idx), 'YData', temp_data(1:idx)); % set the value of the empty figure, X is the time value, Y is the temperature value
    drawnow; % update the figure

    if temp < 18
        % the first condition (temperature values are lower than 18 C)
        writeDigitalPin(a, 'D3', 0);  
        writeDigitalPin(a, 'D7', 0);  
        writeDigitalPin(a, 'D5', 1); % turn on the yellow LED
        pause(0.5); % set the interval to be 0.5
        writeDigitalPin(a, 'D5', 0); % turn off the yellow LED
        pause(0.5); % set the interval to be 0.5
    elseif temp > 24
        % the second condition (temperature values are greater than 24 C)
        writeDigitalPin(a, 'D3', 0);  
        writeDigitalPin(a, 'D5', 0);  
        writeDigitalPin(a, 'D7', 1); % turn on the red LED
        pause(0.25); % set the interval to be 0.25
        writeDigitalPin(a, 'D7', 0); % turn off the yellow LED
        pause(0.25); % set the interval to be 0.25
    else
        % the third condition (temperature values ranges from 18 to 24 C)
        writeDigitalPin(a, 'D3', 1); % turn on the green LED constantly
        writeDigitalPin(a, 'D5', 0); 
        writeDigitalPin(a, 'D7', 0);
    end
    
    idx = idx + 1; % update the index of the data, and store the next data 
    if idx > 30 % if the data is more than 30 points, cover the stored data and start from 1
        idx = 1;
    end
    %set the sampling interval to be 1 second
    pause_time = toc - time; % if the time consumed to run the code smaller than one and make a pause
    if pause_time < 1
        pause(1 - pause_time);
    end
end
end