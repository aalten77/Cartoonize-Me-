% Implements bilateral filter for color images.
function G = bilateral2(I, dim_w, sigma_d, sigma_r)
[M, N] = size(I);
padsize = floor(dim_w/2);
I = padarray(I, [padsize padsize]);

%domain kernel 
[X,Y] = meshgrid(-padsize:padsize,-padsize:padsize);
Domain = exp(-(X.^2+Y.^2)/(2*sigma_d^2));


Range = zeros(dim_w,dim_w);
W = zeros(dim_w,dim_w);
G = zeros(M, N);

for j=padsize+1:N+padsize
    for i=padsize+1:M+padsize
        threebythree = I(i-padsize:i+padsize, j-padsize:j+padsize);
        pixelinfocus = I(i, j);
        for l=1:dim_w
            for k=1:dim_w
                    %build range kernel
                    Range(k,l) = exp(-(pixelinfocus-threebythree(k,l))^2/(2*sigma_r^2));
            end
        end
        %bilateral weight function (Domain and Range multiplied)
        W = Domain.*Range;
        W = W([1:floor(end/2), (floor(end/2)+2):end]);
        W = W(:);
        threebythree = threebythree([1:floor(end/2), (floor(end/2)+2):end]);
        threebythree = threebythree(:);
        %bilateral filter
        G_num = sum(threebythree.*W);
        G_denom = sum(W);
        G(i-padsize,j-padsize) = G_num/G_denom;
    end
end

end