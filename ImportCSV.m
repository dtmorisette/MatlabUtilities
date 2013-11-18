function d = ImportCSV(fname, varargin)
% ImportCSV - Import a CSV file. 
%
% d = ImportCSV(fname) Imports the CSV file pointed to by the path spcified
% in 'fname'. Each column in the file becomes a vector in the returned 
% structure. The column headers in the file are used as the field names.
%
% Supported options:
%
%   'skip', (default: 0)
%       Skips the specified number of lines in the file
%
%   'delim' (default: ',')
%       Allows the user to specify a custom column delimiter character
%
% Copyright (c) 2013 Dallas T. Morisette.
%
    ip = inputParser;
    ip.addRequired('fname')
    ip.addParamValue('skip', 0, @isscalar);
    ip.addParamValue('delim', ',');
    ip.parse(fname, varargin{:});

    d.fname = fname;
    fid = fopen(fname);
    
    for i  = 1:ip.Results.skip + 1
        remain = lower(fgetl(fid));
    end
    
    d.headers = {};
    d.n = 0;
    while ~isempty(remain)
        [str remain] = strtok(remain,ip.Results.delim); 
        tokens = regexp(str, '([a-zA-Z0-9_]+)[\((\d+)\)]?','tokens');
        if ~isempty(tokens)
            d.n = d.n + 1;
            if ~any(ismember(d.headers, tokens{1}{1}))
                temp = tokens{1}{1};
                temp(1) = upper(temp(1));
                d.headers{end+1} = temp;
            end
        end
    end
    d.m = length(d.headers);    % Number of parameters
    d.n = d.n/d.m;              % Number of columns of each parameter
    format = [repmat('%s', 1, d.n*d.m) '%*[^\r\n]'];
    fclose(fid);
    
    fid = fopen(fname);
    data = textscan(fid, format, 'Delimiter', ip.Results.delim, 'HeaderLines', ip.Results.skip+1);
    for i = 1:d.m
        temp = [];
        for j = 1:d.n
            temp(:,j) = str2double(data{(j-1)*d.m+i});
        end
        d = setfield(d, d.headers{i}, temp);
    end 
    fclose(fid);
end