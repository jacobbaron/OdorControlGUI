function  runCleanCycle( all_valves, time_on)
%Clean bubbles of each channel while protect the larvae from odor.
%   open odor channels one-by-one for a time period defined by time_on,
%   water channel always flow through the larvae.
%   For the input all_valves, 
%   1st channel is control_water channel,
%   2nd channel is control_odor channel,
%   3rd channel is water channel,
%   other channels are odor channels.

channel_num = length(all_valves);
command_seq = zeros(channel_num-1, channel_num);

command_seq(:, 1) = 1;   % control water channl always on
command_seq(:, 3) = 1;   % water channel alwayse on
command_seq(1, 2) = 1;       % start at no odor.
command_seq(end,2) = 1;      % end with no odor.
for i =2:channel_num-2   %open all the odor channels one by one
    command_seq(i, i+2) =1;
end

for i =1:channel_num-1
%     disp(command_seq(i,:));
    smset(all_valves, command_seq(i,:));
    pause(time_on);
end

end