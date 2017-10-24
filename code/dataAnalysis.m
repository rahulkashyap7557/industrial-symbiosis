
% Wherever needed change a_finalDeadList with a_aliveList and replace
% a_historyLength = 0, to get measures only for that snapshot
% In the second loop, change a_j = 1:1


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Calculate adjacency matrix set for upto previous five iterations
    
    a_historyLength = 5;   
    a_history = zeros(length(a_finalDeadList), a_historyLength); % contains raw history of each dead node   
    a_start = 1;
    measureCollectionRelNodes = []; % calculate any measure or metric for the nodes in the cleaned up data
    measureCollectionConnScaled = []; % calculate any measure or metric for the data synergies - these are scaled here, data is also cleaned up
    measure = zeros(1, a_historyLength + 1); % change
    
    
    for a_i = 1:length(a_finalDeadList)
        % We need to get rid of duplicates
        a_historyIndices = a_finalDeadList(a_i, :);
        a_count = 1;
         measure = zeros(a_historyLength + 1, 1);
        
        for a_j = a_historyIndices(1, 2):-1:max(a_start, (a_historyIndices(1,2) - a_historyLength))
            %[ relevantNodes, a_adjacencyCleaned ] = checkIS(squeeze(adjacencyWhole(a_historyIndices(1, 1), a_historyIndices(1, 2), :, :)));
            %a_adjacencyHistory(a_count, :, :) = a_adjacencyCleaned;
            %measure(a_count) = length(a_adjacencyHistory(a_count, :, :));
            measureRelNodes(a_count) = numRelevantNodes(a_finalDeadList(a_i, 1), a_j); % Calulate node measure/metric
            a_adjacencySnapshot = squeeze(adjacencyWhole(a_finalDeadList(a_i, 1), a_j, :, :)); % copy snapshot at that particular history index
            measureConn(a_count) = 0.5*sum(sum(a_adjacencySnapshot));
            scale = measureRelNodes(a_count)*(measureRelNodes(a_count) - 1);
            measureConnScaled(a_count) = measureConn(a_count)/scale;
            
            a_count = a_count + 1;             
        end
        
        % Arrange them into a grander matrix
        measureCollectionRelNodes = [measureCollectionRelNodes; measureRelNodes];
        measureCollectionConnScaled = [measureCollectionConnScaled; measureConnScaled];
        
        
        % Measure has been calculated for this particular dead network.
        % Between the **** write plots commands, flush data to file etc
        % etc.
        
        %*******************************************************************
        
        
        
        
        
        
        %*******************************************************************
        
        
        
    end
    
    % Basic plots
    plot(measureCollectionRelNodes./measureCollectionConnScaled)
    
    measureCollectionConnScaled(isnan(measureCollectionConnScaled))=0;    
    measureCollectionConnScaled(~isfinite(measureCollectionConnScaled))=0;
    
    hist(mean(measureCollectionConnScaled, 2), 30)