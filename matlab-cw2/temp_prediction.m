function temp_prediction = time_prediction(a)

    collect_temp = [];      
    duration = 600;     
    
    tic;
    while toc <= duration
        time = toc;
        A0_voltage = readVoltage(a, 'A0');
        current_temp = (A0_voltage - 0.5) / 0.01;
        collect_temp = [collect_temp, current_temp];

        if length(collect_temp) >= 2
            delta_temp = current_temp - collect_temp(1);
            delta_time = length(collect_temp) - 1; 
            rate = (delta_temp / delta_time) * 60;
        else
            rate = 0; 
        end
        predicted_temp = current_temp + rate * 5;  
       
        fprintf('Temperature Changing Rate: %.2f °C/min\tCurrent Temperature: %.2f °C\tPredict Temperature: %.2f °C\n',rate,current_temp,predicted_temp);
    
        if current_temp >= 18 && current_temp <= 24 && abs(rate) <= 4
            writeDigitalPin(a, 'D3', 1);
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        elseif rate > 4
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 1);
        elseif rate < -4
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 1);
            writeDigitalPin(a, 'D7', 0);
        elseif current_temp > 24 && abs(rate) <= 4
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        elseif current_temp < 18 && abs(rate) <= 4
            writeDigitalPin(a, 'D3', 0);
            writeDigitalPin(a, 'D5', 0);
            writeDigitalPin(a, 'D7', 0);
        end

        pause_time = toc - time;
        if pause_time < 1
            pause(1 - pause_time);
        end
    end
end