% Life and Death of Industrial Systems 
% Authors: Rahul Kashyap, Shauhrat S. Chopra
clear all
% Build network
totalRepeats = 1000;
totalIterations = 50;
adjacencyWhole = zeros(totalRepeats, totalIterations, 5+totalIterations, 5+totalIterations);

for repeat = 1:totalRepeats
   

input = importdata('trialMatrix');
adjacencyMatrix = input.data;


probNodeToCore = 0.75;
initCore = 3;
initDensity = 0.5; 
numProp = 4; % no. of node properties

disasterCount = 0;
disasterList = zeros(totalIterations);

for i = 1:length(adjacencyMatrix)    
    nodelist(i) = i;
end


% 4 properties : 1. Size 2. Ecological Capital 3. Social Capital 4. Degree


nodeProperties = zeros(length(adjacencyMatrix), numProp);

% Rows tell us node number and columns tell us property value
nodeProperties = rand(length(adjacencyMatrix), numProp-1);



% Start iterations for addition and deletion
for i = 1:totalIterations
    i
    repeat
    
    
    % Determine whether node is added or removed or nothing happens. Then
    % update the node properties list
    
   %addDel(trialMatrix);
    
    % addDel value determines whether node is added, removed or nothing is
    % changed. if addDel = 1 node added, if addDel = -1 node removed, if
    % addDel = 0, no change
    
    adjacencyMatrixInit = adjacencyMatrix;
    for j = 1:size(adjacencyMatrix, 2)
       nodeProperties(j, 4) = sum(adjacencyMatrix(:, j)); % Update degree of each node
    end
    
    [adjacencyMatrix, nodeProperties, addDelNC, selectedNode] = addDel(adjacencyMatrix, nodeProperties);
    nodeChangesList(i, :) = [i addDelNC selectedNode];
    
    % Next check if any synergies will be added or deleted. Then update the
    % list of synergies
    
    [adjacencyMatrix, addDelSyn, selectedSynergies, scoreSyn] = updateSynergies(adjacencyMatrix, nodeProperties);
    synergyChangesList(i, :) = [i addDelSyn selectedSynergies];

    for j = 1:size(adjacencyMatrix, 2)
       nodeProperties(j, 4) = sum(adjacencyMatrix(:, j)); % update degree of each node
    end
    
    % Calculate eigenvector centrality of adjacency matrix
    eigenVector = eigenvector_centrality_und(adjacencyMatrix);
    adjacencyMatrix;
    
    % Check if disaster happens
    if disasterCount < 2
    
        [ adjacencyMatrix, nodeProperties, disasterList1, disasterCount, disasterC ] = disaster(adjacencyMatrix, nodeProperties, disasterCount);
        w = [i disasterC disasterList1];
        for j = 1:length(w)
            disasterList(i, j) = w(j);
        end
        disasterCount = disasterCount + disasterC;
    end
    
    % Calculate whether node is part of an industrial symbiosis network 
    [ relevantNodes, adjacencyCleaned ] = checkIS(adjacencyMatrix);
    
    % Enter all your calculations here
    % Make sure you place an index for repeats so that values don't get
    % overwritten. Ex: property(repeat, i) = 
    
    numRelevantNodes(repeat, i) = length(relevantNodes);
    adjacencySize(repeat, i) = length(adjacencyMatrix);
    adjacencyWhole(repeat, i, 1:length(adjacencyMatrix), 1:length(adjacencyMatrix)) = adjacencyMatrix;
    nodePropertiesWhole(repeat, i, 1:length(adjacencyMatrix), :) = nodeProperties;
    
        
end
% Add data from this run into data for entire simulation
nodeChangeslWhole(repeat, :, :) = nodeChangesList;
synergyChangesWhole(repeat, :, :) = synergyChangesList;
disasterListWhole(repeat, :, :) = disasterList;




end

% Basic plotting
plot(numRelevantNodes'./adjacencySize', '*')
figure
plot(numRelevantNodes', '*')







