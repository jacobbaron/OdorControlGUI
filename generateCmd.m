function [ cmd_odor,  cmd_temp, period_temp ] = generateCmd( channel_type, all_valves, ...
    sequence_channel, sequence_period, temp_enable, temp_seq_enable, temp_seq_time)
% Figured out the cmd for odor and temperature:
% cmd_odor, sequence_period, cmd_temp, period_temp

cmd_odor = zeros(length(sequence_period), length(all_valves));  %define cmd as the order sequence
switch channel_type
    case 1 %chip type: 1-N
        for i = 1 : 1 : length(sequence_period)
            if sequence_channel(i) == 1 % '1' means water channel on
                cmd_odor(i, 1) = 1; %set water channel and control water channel on
                cmd_odor(i, 3) = 1; 
                if i+1>length(sequence_channel) %check if the last seq
                    cmd_odor(i, sequence_channel(i-1)+2) = 1; %if yes, use its previous odor channel
                else
                    cmd_odor(i, sequence_channel(i+1)+2) = 1; %if not, use its next odor channel
                end
            else %
                cmd_odor(i, 2) = 1; 
                cmd_odor(i, 3) = 1; 
                cmd_odor(i, sequence_channel(i)+2) = 1; 
            end
        end
        
    case 2 %chip type: N-N
        for i = 1 : 1 : length(sequence_period)
            if sequence_channel(i) < length(all_valves)/2
                cmd_odor(i, 1) = 1; 
            else
                cmd_odor(i, 2) = 1; 
            end

            cmd_odor(i, sequence_channel(i)+2) = 1; 

            if i+1>length(sequence_channel)
                cmd_odor(i, sequence_channel(i-1)+2) = 1; 
            else
                cmd_odor(i, sequence_channel(i+1)+2) = 1; 
            end
        end
end

%define the cmd and period for temperature.
cmd_temp = 0;
period_temp = 0;
if temp_enable && temp_seq_enable   %check if temperatue sequence is needed
    temp = find(temp_seq_time ~= 0 );   %count the number of available odors 
    cmd_temp = zeros(length(temp), 2 );  %define the cmd for temperature
    period_temp = temp_seq_time(temp);  %define the time period for each cmd.
    
    for i = 1:length(temp)
        a = temp(i);
        switch rem(a,2)
            case 1  %the case of temperature channel #1
                ss = 1;
            case 0  %the case of temperature channel #2
                ss = 2;
        end
        cmd_temp(i, ss) = 1;
    end
end
end