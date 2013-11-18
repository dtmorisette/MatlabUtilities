function SaveAsCSV(d, fname)
% SaveAsCSV - Save a structure array to a CSV file.
%
% Each vector field of the given structure is written as a column to the
% specified CSV file. Column headers are the field names, and are placed in
% the first row of the file. Any scalar fields are written in the last two
% columns as field name / value pairs. 
%
%  This function is a quick and dirty (read "unstable") mashup so is not
%  expected to be reliable.
%
%  ** Behavior is currently undefined in (at least!) the following cases:
%       Not all vectors are not the same length
%       There are more scalar fields than the length of the vectors
%       
% Copyright (c) 2013 Dallas T. Morisette (morisett@purdue.edu).
% Released under the terms of the FreeBSD License. 
% See LICENSE file for details.
%

    fields = fieldnames(d);
    M = [];
    headers = {};
    j = 1;
    for i = 1:length(fields)
        col = getfield(d,fields{i});
        if isvector(col) && isnumeric(col) && (length(col) > 1)
            if isrow(col)
                col = col';
            end
            headers{j} = fields{i};
            M(:,j) = col;
            j = j+1;
        end
    end
    fid = fopen([fname '.tmp'],'w');
    for i = 1:length(headers)
        fprintf(fid, '%s', headers{i});
        if i ~= length(headers)
            fprintf(fid, ', ');
        end
    end
    fprintf(fid, '\n');
    fclose(fid);
    dlmwrite([fname '.tmp'], M, '-append');
    
    fid_in  = fopen([fname '.tmp'],'rt');
    fid_out = fopen(fname,'wt');
    line = fgetl(fid_in);
    fprintf(fid_out, '%s,Field,Value\n',line);
    for i = 1:length(fields)
        field = fields{i};
        col = getfield(d,fields{i});
        if ischar(col)
            line = fgetl(fid_in);
            fprintf(fid_out, '%s,%s,%s\n',line,fields{i},col);
        elseif isscalar(col)
            line = fgetl(fid_in);
            fprintf(fid_out, '%s,%s,%e\n',line,fields{i},col);
        end
    end
    
    while ~feof(fid_in)
        line = fgetl(fid_in);
        if ischar(line)
            fprintf(fid_out,'%s\n',line);
        end
    end
    
    fclose(fid_in);
    fclose(fid_out);
    
    delete([fname '.tmp']);
end
