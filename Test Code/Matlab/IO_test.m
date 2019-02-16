%Test that IO extraction worked.
% If answer == 0, then it is correct. 
tagid =2;
id1 = 3;
id2 = 14;

%% object dne
answer = sum([TrainingInput{tagid}] - [Features{id1}.' zeros(1,2048)]);

% passive
answer = sum([TrainingInput{tagid}] - [zeros(1,2048) Features{id1}.']);


%% subject and object exist 
%answer = sum([TrainingInput{tagid}] - [Features{id1}.' Features{id2}.']);

% passive
%answer = sum([TrainingInput{tagid}] - [Features{id2}.' Features{id1}.']);

