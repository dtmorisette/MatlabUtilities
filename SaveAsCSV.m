function SaveAsCSV(d, fname)
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
