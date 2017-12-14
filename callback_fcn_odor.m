function callback_fcn_odor(obj, event, init_time, seq, cmd, all_valves)
global counter_odor 

current_time = now;
diff_sec = 10*(current_time - init_time) * 86400; %calculate the time difference, unit: sec
diff = floor(diff_sec);  %cut off at the resolution of 0.1sec

if rem(diff, seq(counter_odor)) == 0 && diff ~= 0
    %//
    smset(all_valves, cmd(counter_odor + 1,:)); %initialize the state of valves. 
%     disp(['Odor queue ', num2str(counter_odor), ' at time ', datestr(event.Data.time,'dd-mmm-yyyy HH:MM:SS.FFF')]);
%     disp(cmd(counter_odor,:));
    counter_odor = counter_odor +1;
    if counter_odor >= length(cmd)
        counter_odor = 1;
    end
end
end