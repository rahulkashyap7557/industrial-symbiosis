function [ adjacencyMatrix, nodeProperties, disasterList1, disasterCount, disasterC ] = disaster(adjacencyMatrix, nodeProperties, disasterCount)
% disaster creates a strong perturbation and selects the fittest nodes in
% the system based on a fitnes criteria

% check whether disaster happens

fate = -3.5 + 4*rand(1,1);

if fate > 0
    disasterCount = disasterCount + 1;
    disasterC = 1;
    
    % select affected node at random
%     j = 1;
%     for i = 1:length(nodeProperties)
%         if nodeProperties(i, 4) ~= 0
%             connectedNodes(j) = i;
%             j = j + 1;
%         end
%         
%     end
%     
%     msize = numel(connectedNodes);
%     impactedNode = connectedNodes(randperm(connectedNodes, 1));
%     
%     % decide whether partial impact or complete impact
%     
%     impactedNodeProperties = nodeProperties(impactedNode, :);

% Large scale impact decimates one half of the network - decided by natural
% selection. 
    
     weight = [1 1 1 1/size(adjacencyMatrix, 2)];
     totalScore = 0;
       
     for i = 1:length(nodeProperties)
         nodeProperties(i, 4) = sum(adjacencyMatrix(i, :));
         score(i) = weight*nodeProperties(i, :)';          
%          score(i) = score(i) + nodeProperties(i, 4)/(size(adjacencyMatrix, 2) - 1); 
     end
     totalScore = sum(score);
       
     contribution = score/totalScore;
     
     % Calculate fitness. Sort in ascending order of fitness and remove
     % connections of the bottom 50%. Therefore, at least 50 percent of the
     % network is offline. We can also calculate fitness giving more
     % weightage to the social capital. 
     
     contributionAscending = contribution;
     contributionAscending(2, :) = 1:length(contribution);
     contributionAscending = sortrows(contributionAscending', 1);
     
     % Filter out the weak nodes - half the population if N is even, N+1/2
     % if N is odd. This is like genetic algorithm.
     
     halfLength = round(0.5*length(contribution));
     
     % All the weakly performing nodes are removed from the network

     weakNodes = contributionAscending(1:halfLength, :);
     
     list = weakNodes(:, 2)';
     
     for i = list
         adjacencyMatrix(i, :) = 0;
         adjacencyMatrix(:, i) = 0;
     end
     
   
     
     disasterList1 = contributionAscending(1:halfLength, 2)';
     
     

% calculate fitness based on node properties and adjacency matrix. Fitness
% is calculated based on the 

else
    disasterList1 = 0;
    nodeProperties = nodeProperties;
    disasterC = 0;
    adjacencyMatrix = adjacencyMatrix;
    disasterCount = disasterCount;
end
    
end
    
    

