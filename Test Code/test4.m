
bbo = BoundingBox{1};
bbi = BoundingBox{6};

if .9*bbo(1) < bbi(1) && .9*bbo(2) < bbi(2) && 1.1*bbo(3) > bbi(3) ...
       && 1.1*bbo(4) > bbi(4)
        
        out = 1;
else
        out = 0;
end