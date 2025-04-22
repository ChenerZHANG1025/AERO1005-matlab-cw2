function temp_prediction = time_prediction(a)
% TEMP_PREDICTION is a function of 
    collect_temp = [];  % set an empty array for the collect temperature data     
    tic; % start the timer
    while true % set the infinite time for the loop
        time = toc; % set the variable 'time' as the time required to run the code
        A0_voltage = readVoltage(a, 'A0'); % record the voltage of the temperature sensor which is connect to the analogue pin (A0)
        current_temp = (A0_voltage - 0.5) / 0.01; % calculate the temperature based on the voltage
        collect_temp = [collect_temp, current_temp]; % store the collect temperature to the array of cllect temperature

        if length(collect_temp) >= 2 % when there are two temperature points collected, the rate of the changing of temperature can be calculated
            delta_temp = current_temp - collect_temp(1); % the difference in temperature
            delta_time = length(collect_temp) - 1; % the difference in time
            rate = (delta_temp / delta_time) * 60; % calculate the rate, due to the units, times 60
        else
            rate = 0; 
        end
        predicted_temp = current_temp + rate * 5;  % calculate the predicted temperature
        fprintf('Temperature Changing Rate: %.2f °C/min\tCurrent Temperature: %.2f °C\tPredict Temperature: %.2f °C\n',rate,current_temp,predicted_temp);
        % print the rate, the current temperature and the predicted
        % temperature to the screen
        if current_temp >= 18 && current_temp <= 24 && abs(rate) <= 4
            % the first condition (comfortable range and -4 < rate < 4)
            writeDigitalPin(a, 'D3', 1); % turn on the green LED
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        elseif rate > 4
            % the second condition (rate > 4)
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 1); % turn on the red LED
        elseif rate < -4
            % the third condition (rate < -4)
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 1); % turn on the yellow LED
            writeDigitalPin(a, 'D7', 0);
        elseif current_temp > 24 && abs(rate) <= 4
            % the forth condition (temperature > 24 and -4 < rate < 4)
            writeDigitalPin(a, 'D3', 0); % no LED lights on
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        elseif current_temp < 18 && abs(rate) <= 4
             % the fifth condition (temperature < 18 and -4 < rate < 4)
            writeDigitalPin(a, 'D3', 0); % no LED lights on
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        end
        % set the sampling interval to be 1 second
        pause_time = toc - time; % if the time consumed to run the code smaller than one and make a pause
        if pause_time < 1
            pause(1 - pause_time);
        end
    end
end