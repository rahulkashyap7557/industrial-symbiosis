function [ relevantNodes, adjacencyCleaned ] = checkIS( adjacencyMatrix )
% checkIS lists the nodes which are connected in any possible IS type
% network i.e. at least three nodes with two connections. So every row i
% that has a nonzero entry with another column having non-zero entry is in
% IS. 



w = 1;
relevantNodes = [];
adjacencyCleaned = [];

for i = 1:length(adjacencyMatrix)
    vector = adjacencyMatrix(i, :);
    while sum(vector) > 0
        k1 = find(vector>0);
        if length(k1) == 1
            vector2 = adjacencyMatrix(k1, :);
            vector2(i) = 0;
            k2 = find(vector2>0);
            if length(k2) > 0
               relevantNodes(w) = i;
               w = w+1;
            end
            break
            
        elseif length(k1) > 1
            relevantNodes(w) = i;
            w = w+1;
            break
        end
        
    end
end

if length(relevantNodes)>0
     adjacencyCleaned = adjacencyMatrix(relevantNodes, relevantNodes);
end
            
        


end

