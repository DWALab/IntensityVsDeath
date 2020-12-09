function [bin_center percent_positive num_of_cells]  = BinDataGetPercentPositive(x,y,bins)
 data_points_per_bin = 5;
 bin_center= nan(1,length(bins) - 1); 
 percent_positive = nan(1,length(bins) -  1) ; 
 num_of_cells = nan(1,length(bins) - 1); 
 
for i = 1:length(bins)-1
    lower = bins(i);
    upper = bins(i+1);
   % center = (upper + lower) /2;
   % center = center + lower ;  
    elements = find(x > lower & x <= upper);
    if(length(elements) > data_points_per_bin)
        
        bin_center(1,i) = mean(x(elements));
        %find the number of non-zero elements
        curr_elements = y(elements);
        percent_positive(1,i) = 100 * double(sum(curr_elements)/ length(curr_elements));
        num_of_cells(1,i) = sum(curr_elements); 
    end
end
end