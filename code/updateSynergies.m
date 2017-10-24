function [ adjacencyMatrix, addDelSyn, selectedSynergies, scoreSyn] = updateSynergies( adjacencyMatrix, nodeProperties )
% updateSynergies: Adds or removes connections between nodes

 % Determine whether node is added or removed or nothing happens
    
    % If fate> 0, node added
    % If fate < 0 node removed, if fate = 0, no change
    
    % generate random number between -2 and 2. If number > 0, node added
    % If number < 0 node removed, if number = 0, no change
    selectedSynergies = [0 0];

fate = -1 + 4*rand(1,1);

    if fate > 0
        addDelSyn = 1;
%         printf('Node needs to be added');
    end
    if fate < 0
        addDelSyn = -1;
%         printf('Node needs to be removed');
    end
    if fate == 0
        addDelSyn = 0;
%         printf('No change to system');        
    end
    scoreSyn = zeros(size(adjacencyMatrix));
     scoreSynTemp = scoreSyn;
     
    % Rescale node degree to value between 0 and 1 
    weight = [1 1 1 1/size(adjacencyMatrix, 2)];
   
    % Calculate the score for every pair of nodes in the network
   for i = 1:size(adjacencyMatrix, 2)
        nodeProperties(i, 4) = sum(adjacencyMatrix(i, :));
        score1 = weight*nodeProperties(i, :)';
        for j = i:size(adjacencyMatrix, 2)
             nodeProperties(j, 4) = sum(adjacencyMatrix(j, :));
             score = weight*nodeProperties(j, :)';
             scoreSyn(i, j) = 0.5*(score1 + score);
           %  scoreSyn(j, i) = scoreSyn(i, j);
        end
   end
   
   for i = 1:size(adjacencyMatrix, 2)
       scoreSyn(i, i) = 0;
   end
   
   scoreSynTemp = scoreSyn;
   
   % Next look for pair of nodes with maximum pair-score. Then assign forma
   %  synergy between those two nodes. A synergy may already exist, in that
   %  case look for the next highest score and repeat for a few times till
   %  a pair is found or exit after minimum number of searches
     
   if addDelSyn == 1
       k = 1;
       
       while k < 10
           
       [maxScoreRow, i] = max(max(scoreSynTemp, [], 2));
       [maxScoreColumn, j] = max(max(scoreSynTemp, [], 1));
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       % Uncomment these two commands if random synergy addition is needed
       
%       for randLoop = 1:10
%        
%        i = randperm(length(adjacencyMatrix), 1);
%        j = randperm(length(adjacencyMatrix, 1));
%        if i ~= j
%           break
%        end
%        end

       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       if adjacencyMatrix(i, j) == 0
             adjacencyMatrix(i, j) = 1;
             adjacencyMatrix(j, i) = 1;
             selectedSynergies = [i j];
             break
      
       else
           scoreSynTemp(i, j) = 0;
           scoreSynTemp(j, i) = 0;
       end
       k = k  +1;
       end
       
    

    
       
   end
   
   % Synergy deletion works similarly to synergy addition. However, pair
   % deletion now works on inverse of score i.e. least performing pairs
   % lose their synergies
   if addDelSyn == -1
       
          for i = 1:size(adjacencyMatrix, 2)
              for j = 1:size(adjacencyMatrix, 2)
                   if scoreSyn(i, j) == 0;
                       scoreSynTemp(i, j) = 50;
                       
                   end
              end
          end
                 k = 1;
       
       while k < 10
           
       [maxScoreRow, i] = min(min(scoreSynTemp, [], 2));
       [maxScoreColumn, j] = min(min(scoreSynTemp, [], 1));
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       % Uncomment following lines to remove synergies randomly
       
%       for randLoop = 1:10
%        
%        i = randperm(length(adjacencyMatrix), 1);
%        j = randperm(length(adjacencyMatrix, 1));
%        if i ~= j
%           break
%        end
%        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       
       if adjacencyMatrix(i, j) ~= 0
             adjacencyMatrix(i, j) = 0;
             adjacencyMatrix(j ,i) = 0;
             selectedSynergies = [i j];
             break
      
       else
           scoreSynTemp(i, j) = 50;
           scoreSynTemp(j, i) = 50;
       end
       k = k  +1;
       end
       
          scoreSynTemp;
       [minScoreRow, i] = min(min(scoreSynTemp, [], 2));
       [minScoreColumn, j] = min(min(scoreSynTemp, [], 1));
       adjacencyMatrix(i, j) = min(0, adjacencyMatrix(i, j));
       selectedSynergies = [i j];
       
       
   end
   
   % Slim chance that no new synergies are added or deleted.
   if addDelSyn == 0
       adjacencyMatrix = adjacencyMatrix;
   end      
        

end

