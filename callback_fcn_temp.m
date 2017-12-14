function callback_fcn_temp(obj, event, init_time, seq, cmd, all_valves)
global counter_temp 

current_time = now;
diff_sec = 10*(current_time - init_time)*86400; %calculate the time difference, unit: sec
diff = floor(diff_sec) ; %cut off at the resolution of 0.1sec

if rem(diff, seq(counter_temp)) == 0 && diff ~= 0
    %//
    smset(all_valves,cmd(counter_temp +1,:)); %initialize the state of valves. 
%     disp(['Temperature queue ', num2str(counter_temp), ' at time ', datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);
%     disp(cmd(counter_temp,:));    
    counter_temp = counter_temp +1;
    if counter_temp >= length(cmd)
        counter_temp = 1;
    end

end
end