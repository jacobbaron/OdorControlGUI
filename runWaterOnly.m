function  runWaterOnly( all_valves)
%Clean bubbles of each channel while protect the larvae from odor.
%   open odor channels one-by-one for a time period defined by time_on,
%   water channel always flow through the larvae.
%   For the input all_valves, 
%   1st channel is control_water channel,
%   2nd channel is control_odor channel,
%   3rd channel is water channel,
%   other channels are odor channels.

cmd = zeros(1, length(all_valves));
cmd(1,3) = 1;
% disp(cmd);
smset(all_valves, cmd);

end