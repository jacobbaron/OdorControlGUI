function [ cmd, period, all_valves ] = mergeCmd(cmd_odor, period_odor, odor_channels, cmd_temp, period_temp, temp_channels)
%MERGECMD combine the cmd of odor and temperature.

if cmd_temp == 0; %No temperature cmd
    all_valves = odor_channels;
    cmd = cmd_odor;
    period = period_odor;
else
    all_valves = [odor_channels; temp_channels]; %merge the channels.
    
    period_odor_sum = zeros(1, length(period_odor)); %get the timeline for odor cmd
    for i=1:length(period_odor) 
        period_odor_sum(i) = sum(period_odor(1:i));
    end
    
    period_temp_sum = zeros(1, length(period_temp)); %get the timeline for tmeperature cmd
    for i=1:length(period_temp) 
        period_temp_sum(i) = sum(period_temp(1:i));
    end
    
    s1 = size(cmd_odor); %get the size of the cmd matrix 
    s2 = size(cmd_temp);
    cmd = zeros(1, s1(2)+s2(2)); 
    cmd(1, :) = [cmd_odor(1,:) cmd_temp(1,:)];
    
    period_sum = zeros(1, 1);
    
    i =1; j=1; n=1; %define counters 
    while i<=length(period_odor_sum) && j<=length(period_temp_sum)
        
        if period_odor_sum(i) < period_temp_sum(j) %need to update the odor cmd
            period_sum(1, n) = period_odor_sum(i); %update the period_sum info
            
            if i+1 <= length(period_odor_sum) %check the index still available
                cmd(n+1, :) = [cmd_odor(i+1,:) cmd_temp(j,:)]; %update the cmd info
            end
            i=i+1; n=n+1;
            
        elseif period_odor_sum(i) > period_temp_sum(j) %need to update the temp cmd
            period_sum(1, n) = period_temp_sum(j); %update the period_sum info
            
            if j+1 <= length(period_temp_sum) %check the index still available
                cmd(n+1, :) = [cmd_odor(i,:) cmd_temp(j+1,:)]; %update the cmd info
            end
            j=j+1; n=n+1;
            
        else %need to updat the cmd of both
            period_sum(1, n) = period_temp_sum(j); %update the period_sum info
            
            if j+1 <= length(period_temp_sum) && i+1 <= length(period_odor_sum)
                cmd(n+1, :) = [cmd_odor(i+1,:) cmd_temp(j+1,:)]; %update the cmd info
            end
            i=i+1; j=j+1; n=n+1;
        end
    end
    
    period = zeros(1,length(period_sum));
    period(1) = period_sum(1);
    for i=2:length(period_sum) 
        period(i) = period_sum(i)-period_sum(i-1);
    end

end