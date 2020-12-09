% THIS SCRIPT WAS CREATED BY DR. NEHAD HIRMIZ
    % anyone who uses this script, even with modifications, please
    % cite https://github.com/DWALab/IntensityVsDeath in acknowledgments.  Thank you!

%YOU MUST SPECIFICY THE NUMBER OF COLUMNS (line 22) and FORMAT in (line 33)
%OPEN your file in excel and count the number of columns to input (line 22)
%look at the type of data and specify (line 33)
    % for whole number input %d   
    % for decimal input %f
    % for text input %s
    % for array of data ie [x,x,x] input %q
%SPECIFY BINS in (line 105)
%DECIDE whether you want to add an OPTIONAL mCerulean3 FILTER in (line 125)

clear all;
close all; 
%INPUT YOUR FILE NAME below and leave .txt
filename = 'Objects_Population - Nuclei remove borders.txt';
fid = fopen(filename);
formatSpec = '%s';

N = 41;
col_title = textscan(fid,formatSpec,N,'Delimiter','\t', 'Headerlines', 9);
disp('PLEASE CHECK THE COLUMN TITLES MATCH EXACTLY THE COLUMN TITLES SPECIFIED after keep_col_title line 40 below AND results_col_title line 164')
disp('The column titles are :');
disp(col_title{1});
answer = input('For columns you are interested in analyzing, do titles match (keep_col_title)? Hit ENTER to continue');
% HERE need to make sure fmt line below matches data format 
    % for whole number input %d   
    % for decimal input %f
    % for text input %s
    % for array of data ie [x,x,x] input %q
fmt = '%d	%d	%d	%d	%d	%d	%d	%d	%q	%f	%f	%d	%d	%d	%d	%d	%f	%d	%f	%d	%f	%f	%f	%f	%f	%f	%f	%f	%f	%f	%d	%d	%f	%f	%s	%f	%d	%d	%d	%d	%d';
data = textscan(fid,fmt, 'Delimiter','\t','Headerlines', 1, 'treatAsEmpty','NULL', 'EmptyValue',NaN );

%%% We only need a set of columns for the analysis here we select which
%%% ones we are interested in
%NOTE: for older MATLAB versions greek letters and superscipt numbers � must preceed the char

keep_col_title  = {
    'Row',
    'Column',
    'Nuclei remove borders - Intensity Cell Venus total cells Mean',
    'Nuclei remove borders - Venus positive',
    'Nuclei remove borders - Intensity Cell TMRE of total Mean',
    'Nuclei remove borders - TMRE negative',
    'Nuclei remove borders - Nuclear area total cells Area [�m�]',
    'Nuclei remove borders - Nuclear area total cells Roundness',
    'Nuclei remove borders - SN',
    'Nuclei remove borders - SN & TMRE -ve of total',
    'Nuclei remove borders - Intensity Cell Cerulean total cells Mean',
    'Nuclei remove borders - Cell Area Area [�m�]',
    'Nuclei remove borders - Alive',
    'Nuclei remove borders - Dead',
    'Nuclei remove borders - Venus Intensity in Cell Sum',
    'Nuclei remove borders - mCerulean3 intensity in cell Sum',
    'Nuclei remove borders - TMRE Intensity in Cell Sum'};

count = 1;
member_index = [];
for i  = 1:numel(keep_col_title)
    [tf, idx] = ismember(keep_col_title{i}, col_title{1});
    if(tf)
        member_index(count,1) = idx;
        count = count +1;
    end
end
%find the indecies of columns that are not desired
all_indx = 1:numel(col_title{1});
p=ismember(all_indx,member_index);
non_member_indx = all_indx(~p);

%remove columns that are not part of the desired columns
col_title{1}(non_member_indx)=[];
data(:,non_member_indx) = [];

%make sure that index for rows =1
%make sure that index for cols =2
well_ids(:,1)  = cell2mat(data(1));
well_ids(:,2) = cell2mat(data(2));

unique_well_ids = unique(well_ids,'rows');

results = {};

for i = 1:length(unique_well_ids)
    %my_index = find(unique_well_index == needed_well);
    cur_well_index = unique_well_ids(i,:);
    %find indecies for data belonging to curdrent well
    cur_data_index = find (well_ids(:,1) == cur_well_index(:,1) & well_ids(:,2)== cur_well_index(:,2));
    %only take data belonging to current well
    %igonore first two columns that was used to determine well index
    curr_data = zeros(numel(cur_data_index), numel(data)-2);
    %convert cells to mat
    for i = 1:numel(data)
        curr_data(:,i) = data{i}(cur_data_index);
    end
     
    curr_row = curr_data(1,1);
    curr_col = curr_data(1,2);
    %Pivot column for binning
    bin_col_title = 'Nuclei remove borders - Intensity Cell Venus total cells Mean';
    bin_col_index = FindColIndexByTitle(col_title, bin_col_title);
  %THIS IS WHERE YOU CAN ADJUST BINS
    bins = [0,100,200,225,250,300,350,400,600,800,1000,1500,2000,3000,4000,5000,6000,7000,8000,9000,10000,15000,20000,25000,30000,35000,40000,45000,50000];
    
    
    %Get Fload Data Col index using title
    f_col_index1 = bin_col_index;
    f_col_index2 = FindColIndexByTitle(col_title,'Nuclei remove borders - Intensity Cell TMRE of total Mean');
    f_col_index3 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Nuclear area total cells Area [�m�]');
    f_col_index4 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Nuclear area total cells Roundness');
    f_col_index5 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Intensity Cell Cerulean total cells Mean');
    f_col_index6 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Cell Area Area [�m�]');

    
    %Bin and Apply Binning To Float Data
    [bin_center, bin_avg1, bin_stddev1] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index1)) ,bins);
    [bin_center, bin_avg2, bin_stddev2] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index2)) ,bins);
    [bin_center, bin_avg3, bin_stddev3] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index3)) ,bins);
    [bin_center, bin_avg4, bin_stddev4] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index4)) ,bins);
    [bin_center, bin_avg5, bin_stddev5] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index5)) ,bins);
    [bin_center, bin_avg6, bin_stddev6] = BinDataGetAverage(curr_data(:,bin_col_index), double(curr_data(:,f_col_index6)) ,bins);

%%% OPTIONAL STEPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%THIS IS WHERE YOU CAN ADD AN mCerulean3 intensity filter if you want
%then remove the % in front of 6 lines below and select your mC3 ie upper threshold (750 here)

    %     if(curr_col > 8)
    %         mc3_col_index = FindColIndexByTitle(col_title,  'Nuclei remove borders - Intensity Cell Cerulean total cells Mean'); 
    %         %Find mc3 indecies for data less than 750; 
    %         mc3_low_index = find (curr_data(:,mc3_col_index) < 750); 
    %         curr_data(mc3_low_index,:) = [];
    %     end
             
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    %Get Binary Data Col Index  from Title(0 and 1s)
        
    binary_col_index1 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Venus positive');
    binary_col_index2 = FindColIndexByTitle(col_title, 'Nuclei remove borders - TMRE negative');
    binary_col_index3 = FindColIndexByTitle(col_title, 'Nuclei remove borders - SN');
    binary_col_index4 = FindColIndexByTitle(col_title, 'Nuclei remove borders - SN & TMRE -ve of total');
    binary_col_index5 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Alive');
    binary_col_index6 = FindColIndexByTitle(col_title, 'Nuclei remove borders - Dead');

    %Bin data and apply binning to binary data
    [bin_center,bin_per_positive1,bin_count1] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index1)) ,bins);
    [bin_center,bin_per_positive2,bin_count2] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index2)) ,bins);
    [bin_center,bin_per_positive3,bin_count3] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index3)) ,bins);
    [bin_center,bin_per_positive4,bin_count4] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index4)) ,bins);
    [bin_center,bin_per_positive5,bin_count5] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index5)) ,bins);
    [bin_center,bin_per_positive6,bin_count6] = BinDataGetPercentPositive(curr_data(:,bin_col_index), double(curr_data(:,binary_col_index6)) ,bins);

    
    if(cur_well_index == 53)
        plot(bin_center, bin_per_positive6, 'ko');
      % plot(curr_data(:,bin_col_index), double(curr_data(:,f_col_index4)) , 'ro'); 
       disp('plot'); 
    end
    %create row nad col columns with size equal to binned data
    rows_col  = ones(size(bin_center)) * curr_row;
    cols_col = ones(size(bin_center)) * curr_col;
    results_col_title = {'Row',
        'Column',
        'Nuclei remove borders - Intensity Cell Venus total cells Mean - Average' ,
        'Nuclei remove borders - Intensity Cell Venus total cells Mean - StdDev' ,
        'Nuclei remove borders - Intensity Cell TMRE of total Mean - Average',
        'Nuclei remove borders - Intensity Cell TMRE of total Mean - StdDev',
        'Nuclei remove borders - Nuclear area total cells Area [�m�] - Average',
        'Nuclei remove borders - Nuclear area total cells Area [�m�] - StdDev',
        'Nuclei remove borders - Nuclear area total cells Roundness - Average',
        'Nuclei remove borders - Nuclear area total cells Roundness - StdDev',
        'Nuclei remove borders - Intensity Cell Cerulean total cells Mean - Average',
        'Nuclei remove borders - Intensity Cell Cerulean total cells Mean -StdDev',
        'Nuclei remove borders - Cell Area Area [�m�] - Average',
        'Nuclei remove borders - Cell Area Area [�m�] - StdDev',
        'Nuclei remove borders - Venus positive - Percent Positive',
        'Nuclei remove borders - Venus positive - Cell Count',
        'Nuclei remove borders - TMRE negative - Percent Positive',
        'Nuclei remove borders - TMRE negative - Cell Count',
        'Nuclei remove borders - SN - Percent Positive',
        'Nuclei remove borders - SN - Cell Count',
        'Nuclei remove borders - SN & TMRE -ve of total - Percent Positive',
        'Nuclei remove borders - SN & TMRE -ve of total - Cell Count'
        'Nuclei remove borders - Alive - Percent Positive'
        'Nuclei remove borders - Alive - Cell Count'
        'Nuclei remove borders - Dead - Percent Positive'
        'Nuclei remove borders - Dead - Cell Count'
        };
    
    
    curr_results ={rows_col' cols_col' bin_avg1' bin_stddev1' bin_avg2' bin_stddev2' bin_avg3' bin_stddev3' bin_avg4' bin_stddev4' bin_avg5' bin_stddev5' bin_avg6' bin_stddev6' bin_per_positive1' bin_count1' bin_per_positive2' bin_count2' bin_per_positive3' bin_count3' bin_per_positive4' bin_count4' bin_per_positive5' bin_count5' bin_per_positive6' bin_count6'};
    results = vertcat(results,curr_results);
    
end

[ss,tt] = xlswrite('analysis_column_titles_LC.xls', results_col_title);
[ss,tt] = xlsappend('analysis_results_LC.xls', results);

display('ANALYSIS COMPLETE :) ');


