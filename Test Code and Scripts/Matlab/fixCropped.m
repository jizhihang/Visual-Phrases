% Save croppedImage.
%{

CroppedImages{3} = CroppedImages{1};
CroppedImages{4} = CroppedImages{2};

Features{4} = Features{2};
Features{3} = Features{1};
%}


cd G:\Documents\Visual_Phrases_Project\CroppedImages

save('3000_000793.mat', 'CroppedImages', 'Tags', 'BoundingBox', 'Features');

cd G:\Documents\Visual_Phrases_Project\
