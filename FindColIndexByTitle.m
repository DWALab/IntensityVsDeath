%This is a simple script to extract the column index from a list of column
%titles
%written by Nehad Hirmiz

function index = FindColIndexByTitle(array_col_title, str_col_title)
index = strfind(array_col_title{1}, str_col_title);
index = find(not(cellfun('isempty', index)));
end