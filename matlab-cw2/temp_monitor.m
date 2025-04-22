function temp_monitor = temp_monitor(a)
% TEMP_MONITOR is a function based on the temperature collected by the
% temperature sensor which is connected to arduino and pass the information
% by using the arduino.
%
% TEMP_MONITOR = TEMP_MONITOR(a) is worked with the variable a, which
% represents the arduino connected to the computer. (e.g.a =
% arduino("/dev/cu.usbserial-10","Uno")), the connected arduino should set
% in the main running file and pass the arduino variable to the function
% here. The function is to monitor the temperature of the cabin. It is used to
% draw the living figure for the temperature changing with the time and
% the temperature by using LED to make the temperature representation more
% direct. If the Green LED lights on, the cabin is in a comfortable
% temperature (18-24 C), when the temperature is greater, the red LED turns
% on, and the yellow one turn on when the temperature is lower than 18 C.
figure;
h = plot(NaN, NaN); 
xlabel('Time (s)');
ylabel('Temperature (Celsius)');
grid on;
xlim([0 600]);
ylim([10 40]);
hold on;

duration = 600;
time_data = NaN(1, duration);
temp_data = NaN(1, duration);
idx = 1;

writeDigitalPin(a, 'D3', 0);
writeDigitalPin(a, 'D5', 0);
writeDigitalPin(a, 'D7', 0);

tic;
while toc <= 600
    time = toc;
    A0_voltage = readVoltage(a, 'A0');
    temp = (A0_voltage - 0.5) / 0.01;
   
    time_data(idx) = time;
    temp_data(idx) = temp;
    set(h, 'XData', time_data(1:idx), 'YData', temp_data(1:idx));

    if time > 600
        xlim([time-600 time]);
    end

    drawnow;
    if temp < 18
        writeDigitalPin(a, 'D3', 0);  
        writeDigitalPin(a, 'D7', 0);  
        writeDigitalPin(a, 'D5', 1); 
        pause(0.5);
        writeDigitalPin(a, 'D5', 0);  
        pause(0.5);
    elseif temp > 24
        writeDigitalPin(a, 'D3', 0);  
        writeDigitalPin(a, 'D5', 0);  
        writeDigitalPin(a, 'D7', 1); 
        pause(0.25);
        writeDigitalPin(a, 'D7', 0); 
        pause(0.25);
    else
        writeDigitalPin(a, 'D3', 1); 
        writeDigitalPin(a, 'D5', 0); 
        writeDigitalPin(a, 'D7', 0);
    end
    
    idx = idx + 1;
    if idx > duration
        idx = 1;
    end
    pause_time = toc - time;
    if pause_time < 1
        pause(1 - pause_time);
    end
end
end