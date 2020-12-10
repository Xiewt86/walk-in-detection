function int = find_blank (d)
int = [];
start = -1;
term = -1;
for i = 1 : length(d)
    if d(i) == 0
        if (term == -1) && (start == -1)
            start = i;
        end
    elseif start ~= -1
        term = i-1;
        int = [int; [start, term]];
        start = -1;
        term = -1;
    end
end
end