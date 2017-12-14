function  runCloseAll( all_valves)
%Clean bubbles of each channel while protect the larvae from odor.
%   open odor channels one-by-one for a time period defined by time_on,
%   water channel always flow through the larvae.
%   For the input all_valves, 
%   1st channel is control_water channel,
%   2nd channel is control_odor channel,
%   3rd channel is water channel,
%   other channels are odor channels.

% disp(zeros(1, length(all_valves)));
smset(all_valves, 0);

end