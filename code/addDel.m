function [ adjacencyMatrix, nodeProperties, addDelNC, selectedNode ] = addDel(adjacencyMatrix, nodeProperties )
%addDel Adds or removes nodes in a network
%   Detailed explanation goes here


    % Determine whether node is added or removed or nothing happens
    
    % If fate> 0, node added
    % If fate < 0 node removed, if fate = 0, no change
    
    % generate random number between -2 and 2. If number > 0, node added
    % If number < 0 node removed, if number = 0, no change
    
    fate = -1 + 4*rand(1,1);

    if fate > 0
        addDelNC = 1;
%         printf('Node needs to be added');
    end
    if fate < 0
        addDelNC = -1;
%         printf('Node needs to be removed');
    end
    if fate == 0
        addDelNC = 0;
%         printf('No change to system');        
    end
    
     
          
    
    
    % addDel value determines whether node is added, removed or nothing is
    % changed. if addDel = 1 node added, if addDel = -1 node removed, if
    % addDel = 0, no change
    
    if addDelNC == 1
        
        % Node must be added. First decide which type of node is to be
        % added. There can be four types of new nodes. 1. Impartial node 2.
        % Node partial to Size 3. Node partial to Ecological Capital 4.
        % Node Partial to Social Capital
        
        % Generate random number to decide which node wants to join. If
        % 0 < type < 0.25 -> node type 1
        % 0.25 < type < 0.5 -> node type 2
        % 0.5 < type < 0.75 -> node type 3
        % 0.75 < type < 1 -> node type 4
        
%         type = rand(1,1);
%         
%         if (type >= 0) &&(type <= 0.25)
%             weight = [1 1 1];
%         end
%         
%         if (type > 0.25) && (type <= 0.5)            
%             weight = [2 1 1];            
%         end
%         
%         if (type > 0.5) && (type <= 0.75)
%             weight = [1 2 1];
%         end
%         
%         if (type > 0.75) && (type <= 1.0)
%             weight = [1 1 2];
%         end

% The score of each node is calculated based on the node properties. Adjust
% all the properties to lie between 0 and 1
     weight = [1 1 1 1/size(adjacencyMatrix, 2)];
     totalScore = 0;
       
     % Calculate total score
     for i = 1:length(nodeProperties)
         nodeProperties(i, 4) = sum(adjacencyMatrix(i, :));
         score(i) = weight*nodeProperties(i, :)';          
%          score(i) = score(i) + nodeProperties(i, 4)/(size(adjacencyMatrix, 2) - 1); 
     end
     totalScore = sum(score); % total network score
       
     % Calculate the contribution of each node to the total network score
     contribution = score/totalScore;
     
     % Next make a list with fraction of total contribution of each node to
     % the total score. 
     range = zeros(length(nodeProperties), 1);
     rangeInter = 0;
       
     for i = 1:length(range)
         rangeInter = rangeInter + contribution(i);
         range(i) = rangeInter;
     end
     
     %Use if needed for random addition of nodes
     
     % range = 0:1/length(adjacencyMatrix):1
         
     % Then create a random number between 0 and 1. Probability that node i
     % is selected by incoming node is then proportional to the fraction of the score
     % contributed by that node
     nodeSelectCondition = rand;
       
     for i = 1:length(range)
           
         if nodeSelectCondition <= range(i)
             selectedNode = i;
             break
         end
           
     end
     
     % Update adjacency matrix with new node and its properties. 
     initSystemSize = length(adjacencyMatrix);
     newSize = initSystemSize + 1;
     adjacencyTemp = zeros((newSize));
     adjacencyTemp(1:initSystemSize, 1:initSystemSize) = adjacencyMatrix;
     adjacencyTemp(newSize, selectedNode) = 1;
     adjacencyTemp(selectedNode, newSize) = 1;
     adjacencyMatrix = adjacencyTemp;    
     newNodeProperties = rand(1, size(nodeProperties, 2));
     newNodeProperties(4) = 1;
     nodeProperties = [nodeProperties; newNodeProperties];
       
       
     
     
%      printf('new node has been added to node %d', selectedNode);
     
    end
    
    % How to delete node
        
    
    if addDelNC == -1
      weight = [1 1 1 1./size(adjacencyMatrix, 2)];
     totalScore = 0;
     
     % Calculate score of each node and fraction of total score contributed
     % to by each node
     for i = 1:length(nodeProperties)
         nodeProperties(i, 4) = sum(adjacencyMatrix(i, :));
         score(i) = weight*nodeProperties(i, :)';          
           
     end
     
     totalScore = sum(score);
     
     % We try to identify poorly performing nodes. The idea is again to
     % create a list with inverse fraction of total contribution. 
     contribution = score/totalScore;
         inverseContribution = 1./contribution;
         totalInverseContribution = sum(inverseContribution);
         fractionInverseContribution = inverseContribution/totalInverseContribution;
            
         range = zeros(length(nodeProperties), 1);
         rangeInter = 0;
       
     for i = 1:length(range)
         rangeInter = rangeInter + contribution(i);
         range(i) = rangeInter;
     end
     
     % Now calculate random number between 0 and 1. The probability that
     % node i is selected for removal is inversely proportional to its
     % contribution i.e. weaker nodes have a greater chance of being kicked
     % out.
       
         nodeSelectCondition = rand;
         
     %Use if needed for random addition of nodes
     
     % range = 0:1/length(adjacencyMatrix):1
       
     for i = 1:length(range)
           
         if nodeSelectCondition <= range(i)
             selectedNode = i;
             break
         end
           
     end
%        initSystemSize = length(adjacencyMatrix);
%        newSize = initSystemSize - 1;
%        adjacencyTemp = zeros((newSize));
%        adjacencyTemp(1:initSystemSize, 1:initSystemSize) = adjacencyMatrix;
%        adjacencyTemp(newSize, selectedNode) = 1;
%        adjacencyTemp(selectedNode, newSize) = 1;
%        adjacencyMatrix = adjacencyTemp;
%        adjacencyMatrix(i, :) = [];
%        adjacencyMatrix(:, i) = [];
%        nodeProperties(i, :) = [];

     % Update adjacency matrix but removing the node completely from the
     % graph. However, don't shrink the matrix. Once a node enters a
     % system, it doesn't leave. It's like an entry in an address book.
     % Even if the node is removed, it may have a chance to re-enter the
     % system by adding a synergy.
     adjacencyMatrix(:, i) = 0;
     adjacencyMatrix(i, :) = 0;
       
%        printf('Node %d has been removed', selectedNode);
       
    end
    
     
    % Slim possibility that no new nodes are added or deleted.
     if addDelNC == 0;
        adjacencyMatrix = adjacencyMatrix;
        nodeProperties = nodeProperties;
     end
    


end

