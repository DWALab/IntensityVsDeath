function [bin_center bin_y std_err_y]  = BinDataGetAverage(x,y,bins)
 data_points_per_bin = 5;
 bin_center= nan(1,length(bins) - 1); 
 bin_y = nan(1,length(bins) -  1) ; 
 std_err_y = nan(1,length(bins) - 1); 
 
for i = 1:length(bins)-1
    lower = bins(i);
    upper = bins(i+1);
   % center = (upper + lower) /2;
   % center = center + lower ;  
    elements = find(x >= lower & x < upper);
    if(length(elements) > data_points_per_bin)
        
        bin_center(1,i) = mean(x(elements));
        bin_y(1,i) = mean(y(elements));
        std_err_y(1,i) = std(y(elements))/sqrt(length(elements));
    end
end
end