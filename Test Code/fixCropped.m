% Save croppedImage.


CroppedImages{6} = CroppedImages{1};
CroppedImages{7} = CroppedImages{2};
CroppedImages{8} = CroppedImages{3};
CroppedImages{9} = CroppedImages{4};
CroppedImages{10} = CroppedImages{5};

Features{6} = Features{1};
Features{7} = Features{2};
Features{8} = Features{3};
Features{9} = Features{4};
Features{10} = Features{5};


cd G:\Documents\Visual_Phrases_Project_DATA\CroppedImages

save('3000_003123.mat', 'CroppedImages', 'Tags', 'BoundingBox', 'Features');


