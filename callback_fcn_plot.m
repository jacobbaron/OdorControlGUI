function callback_fcn_plot(obj, event, init_time, max_y)
global lh

current_time = now;
diff_sec = (current_time - init_time)*86400; %calculate the time difference, unit: sec

delete(lh); %clear the previous time line;
lh = line([diff_sec, diff_sec], [0 max_y], 'Color', 'g', 'LineWidth', 4); %replot the new time line

end