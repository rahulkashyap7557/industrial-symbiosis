% Calculations for life and death data

% First identify networks that are dead based on network size and
% connectivity. Network should have at least one triplet. 
% Calculate the adjacency matrix with all the IS connections. If the matrix
% returns null then it is a dead system. Collect info about both type of
% systems and compare. Do this both for preferential attachment and random
% growth. For dead systems, analyze the network a few time steps earlier to
% determine cause of death/route to death. We need to create network level
% probability distributions of measures (to be defined later). Overlay the
% distributions for comparison. 
a_aliveList = [];
a_deadList = [];
a_finalDeadSequenceIndices = [];


for i = 1:repeat
    for j = 1:totalIterations
        a_adjacencyMatrix = [];
        a_adjacencyCleaned = [];
        a_adjacencyMatrix = squeeze(adjacencyWhole(i, j, :, :));
        [a_relevantNodes, a_adjacencyCleaned] = checkIS(a_adjacencyMatrix);
        checkDead = isempty(a_adjacencyCleaned);
        if checkDead == 1
            a_deadList = [a_deadList; i, j];
        else
            a_aliveList = [a_aliveList; i, j];
        end

        
    end
end





% Step through each i and check for sequence



% [uniqueI, indI, indIInverse] = unique(a_deadList(:, 1));
% a_unrepeatedList = a_deadList;
% % Filter out networks which are dead for consecutive time steps
% v = a_unrepeatedList(:, 2);
% %a_numDeadSequences = cumsum(diff(a_deadList(:,2)~=1)) + 1;
% 
% x = [0 cumsum(diff(v')~=1)];
% a_numDeadSequences = x(length(x)) + 1;
% a_count = 1;





















[uniqueI, indI, indIInverse] = unique(a_deadList(:, 1));
a_count = 1;

for a_count = 1:length(indI)
    
    % Obtain the values of the indices where the new repeat starts and ends
    if (a_count + 1 < length(indI))
    indexList = indI(a_count):indI(a_count+1);
    else
        indexList = indI(a_count):indI(end);
    end
    
    % Obtain the list of dead iterations for that particular repeat.
    % Indices are already known from previous step.
    
    repeatListI = a_deadList(indexList, 2);
    repeatListI = repeatListI(1:end-1);
    
    % Look for possible sequences in the list for each i
    
    v = repeatListI;
    x = [0 cumsum(diff(v')~=1)];
    x = x + 1;
    a_numDeadSequences = x(length(x));
    
    % For each of these sequences, make an entry of indices in a_deadList
    
    for a_sequenceCount = 1:a_numDeadSequences
        
         a_repeatedIndices = find(x == a_sequenceCount);
         if sum(a_repeatedIndices > 1)
             beginning = a_repeatedIndices(1) + indI(a_count) - 1;
             ending = a_repeatedIndices(length(a_repeatedIndices)) + indI(a_count) - 1 ;
             a_finalDeadSequenceIndices = [a_finalDeadSequenceIndices; beginning, ending];
         end
    end
    
         
         
%          repeatsChecklist(:, 1) = repeatListI(a_repeatedIndices(1):(a_repeatedIndices(1) + length(a_repeatedIndices)));
         
    end
    
    % If a repeat has a sequence and also a lone dead network, the array
    % a_finalDeadSequenceIndices stores the second lone dead network index
    % also since it has simply judged that particular repeat as having a
    % sequence. So it does not test whether the second sequence is over
    % length two. Now, search manually for column and column 2 to be equal
    % and remove those rows to get rid of spurious lone network entries.
    
    a_try1 =  setdiff(a_finalDeadSequenceIndices(:,1),a_finalDeadSequenceIndices(:,2),'rows');
    a_try2 =  setdiff(a_finalDeadSequenceIndices(:,2),a_finalDeadSequenceIndices(:,1),'rows');
    
    a_finalDeadSequenceIndices = [a_try1, a_try2];
    
    % Now build a matrix with the non-sequential elements and the first
    % entry in each sequence
    
    % First identify the first element of each sequence. 
    
    a_sequenceSingleListed = a_deadList(a_finalDeadSequenceIndices(:, 1), :);
    
    % Now identify the ones which are not in any sequence
    
    a_nonsequential = a_deadList;
    
    for a_i = 1:length(a_finalDeadSequenceIndices)
        a_nonsequential(a_finalDeadSequenceIndices(a_i,1):a_finalDeadSequenceIndices(a_i, 2), :) = 0;
    end
    a_nonseqtry = a_nonsequential;    
    a_nonseqtry(sum((a_nonseqtry==0),2)>0,:) = [];    
    a_nonsequential = a_nonseqtry; % this is the list of all non sequential dead networks    
    a_finalDeadList = [a_sequenceSingleListed; a_nonsequential];    
    a_finalDeadList = sortrows(a_finalDeadList); % final sorted matrix of dead networks
    

    

















