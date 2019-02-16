load '3000_001786.mat';
load 'OutputGT.mat';

clearTrainingData;

load 'TrainingOutputA.mat';
load 'TrainingInputA.mat';

incr = 1;
NumTags = length(Tags);
while incr <= NumTags
    
    tag = Tags{incr};
    len = length(tag);
    try
        word = strsplit(tag, '_');
    catch
        word = tag;
    end
        
    word_len = length(word);
    fw = {};
    if word_len == 1
        % move to next tag..
        incr = incr + 1;
        continue       
    else
        
        switch(word_len)
            case 2
                % if length is 2, test if tag is for abs neg, if not the second
                % word in the tag is the predicate.
                if strcmp(tag, 'absolute_negatives')
                    phr = tag;
                    fw{1} = tag;
                    fw{2} = 0;
                else
                    phr = word{2};
                    fw{1} = word{1};
                    fw{2} = 0;
                end
            case 3
                phr = word{2};
                fw{1} = word{1};
                fw{2} = word{3};
            case 4
                phr = strcat(word{2}, '_', word{3});
                fw{1} = word{1};
                fw{2} = word{4};
            otherwise
                % should only be at most 4 words in phrase. 
        end
        % Find how many instances there are of the phrase. 
        phrIdx = getStringIdx(Tags, tag, 0);
        numInst = length(phrIdx);
        
        % Get positions of features. If there is no subject, set to 0.
        f1_idx = getStringIdx(Tags, fw{1}, 0);
        
        if fw{2} ~= 0 
            f2_idx = getStringIdx(Tags, fw{2}, 0);            
        else
            f2_idx = 0;
        end
        
        % Count of first feature and second feature.
        %f1c = length(f1_idx) - numInst;
        f2c = length(f2_idx) - numInst;
        
        % Find the corresponding output value
        ou = getStringIdx(OGT(:,1), phr, 1);

        % Find the corresponding passive output value.
        ol = getStringIdx(OGT(:,1), strcat('passive_',phr), 1);

  
        for feat = 1:numInst
            %% set input. info on why this is done below.
            %{ 
             Since the strfind function will return a value if the taget
             string is part of a larger string,we need to account for the
             fact that the 'phrase' will show up as a false positive when
             searching for a subject.
             There will be 'numInst' number of the phrase, and
             the array f1_idx must contain 2*(numInst) values as the
             should have its own cropped image associated with it, so
             starting from the (numInst + 1) index in f1_idx 
             will return the Tag location of the feature
             ex tag list: 
             [person_riding_bicycle, person_riding_bicycle, person, person,
             person, bicycle, bicycle], the first person corresponds with 
             the person in the phrase, and the first bicycle corresponds 
             with the bicycle in the first phrase and so on. 
            %}
            % If image is absolute_negative, there is only 1 tag. make sure
            % that outofbounds error is not created.
            
            bboxCurrent = BoundingBox{incr + feat - 1};
 
           if NumTags > 1
               in1 = Features{f1_idx(feat+numInst)}.';
           else
               in1 = Features{1}.';
           end

           %% Get object feature. 
            % Test if abs_neg or if background/no object. 
            if f2_idx == 0 | f2c == 0
                in2 = zeros(1, 2048);
            else
                for w = 1:f2c
                    bbox_f2 = BoundingBox{f2_idx(w+numInst)};
                    if ~bboxComp(bboxCurrent, bbox_f2)
                        % Test for instance in which 'object' contains the
                        % subject. If not, set feature to a zero array. 
                        if bboxComp(bbox_f2, bboxCurrent)
                            in2 = Features{f2_idx(w+numInst)}.';
                        else   
                            in2 = zeros(1,2048);
                        end

                    else
                       in2 = Features{f2_idx(w+numInst)}.';
                       break
                    end                   
                end               
            end
            
            input = [in1 in2];
            passive_input = [in2 in1];
            %set input and output.  
            %{
            % The output for the same phrase will be the same so there is
            % no need to find the exact index of the instance, only need to
            % insure that there are exactly numInst amounts of inputs and
            % outputs generated for a given phrase. 
            %}
            if ~isempty(ou)
                TrainingOutput{end+1,1} = OGT{ou, 2};
                TrainingInput{end+1,1} = input;
            end
            if ~isempty(ol)
                TrainingOutput{end+1,1} = OGT{ol, 2};
                % Passive Input case.
                TrainingInput{end+1,1} = passive_input;
            end        
            
        end
   
        incr = incr + numInst;
    end
end

save('TrainingOutputA.mat', 'TrainingOutput');
save('TrainingInputA.mat', 'TrainingInput');