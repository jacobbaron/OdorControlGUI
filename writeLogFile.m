function writeLogFile( log_file_path, log_file_name,...
    conc_plus_odor_list,  sequence_channel, sequence_period, ...
    temp_enable, temp_list, tempchannel_state, temp_seq_enable,  temp_seq_time)
% define log file.
full_odor_list  = [ {'Water'}; conc_plus_odor_list]; %add water to the odor list

fName = [log_file_path, log_file_name, '.txt'];  %creat a txt file with the name and path as defined.
fid = fopen(fName,'wt');
fmt='%s\t %d\t\n';

%figure out the name of strain. 
strain_nam = log_file_name(5:end-7);    %strain name is defined as the strings between 'log_' and '_run1xx'.

if fid ~= -1
    %write the name of the strain. 
    fprintf(fid, '%s\r\n', strain_nam); %write the strain name.
    fprintf(fid, '%s\t %s\t\n', 'Odor Type', 'Time(s)');
    
    %write the odor sequence step by step
    for i = 1:length(sequence_period) -1
        fprintf(fid, fmt, full_odor_list{sequence_channel(i),1}, sequence_period(i));
    end
    fprintf(fid, '%s\t %d\t', full_odor_list{sequence_channel(length(sequence_period)),1}, sequence_period(length(sequence_period)));
    
%     fprintf(fid, '\\\n'); %seperate the temperature part
    
    if  temp_enable == 1    %check whether temperature is avialbe. 
        fprintf(fid, '\\\n'); %seperate the temperature part
        if temp_seq_enable == 0 %handle the case of stable temperature
            temp = find(tempchannel_state == 1);    %check which channel is open 
            if length(temp) ~= 1    %if there are not only one channel open, report error and return.
                msgbox('There should be only one temperature channel be open in current setting.', 'Temperature channel error.', 'error');
                return;
            else
                current_T = temp_list(temp);    %find out the current temperature.
            end 
            fprintf(fid, 'Temperature control: ON\n');
            fprintf(fid, 'Temperature is set at\t %d\t\n', current_T); %write the temperature information.
        else %if defined the temperature sequence
            fprintf(fid, 'Temperature sequence: ON\n');
            fprintf(fid, '%s\t %s\t\n', 'Temperature(C)', 'Time(s)');
            
            %write the temperature sequence step by step
            temp = find(temp_seq_time ~=0 );
            for i = 1:length(temp)
                a = temp(i);
                switch rem(a,2)
                    case 1  %the case of temperature channel #1
                        ss = 1;
                    case 0  %the case of temperature channel #2
                        ss = 2;
                end
                fprintf(fid, '%d\t %d\t\n', temp_list(ss), temp_seq_time(a));
            end
        end
    end
    fclose(fid);
end
end