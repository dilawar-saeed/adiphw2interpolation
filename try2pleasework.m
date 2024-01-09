clc;close all;clear

I_Original = imread('mandi.tif');                   % read image
I_Matlab = demosaic(I_Original,'bggr');             % built-in function

[y,x] = size(I_Original);                           % dimensions of image

I = double(I_Original) / 255.0;

% 3 images of same size as original image for each channel
red = zeros(y,x,"double");                          
green = zeros(y,x,"double");
blue = zeros(y,x,"double");


% interpolation of image (apart from boundary pixels)                                                 
for i=2:y-1
    for j=2:x-1
        if(mod(i,2)==0)                             % even numbered row
            if(mod(j,2) == 0)                       % even row even column

                % red pixel
                red(i,j) = I(i,j);
                green(i,j) = (I(i-1,j)+I(i+1,j)+I(i,j-1)+I(i,j+1))/4;
                blue(i,j) = (I(i-1,j-1)+I(i+1,j+1)+I(i-1,j+1)+I(i+1,j-1))/4;
            
            else                                    % even row odd column
                
                %green pixel
                green(i,j) = I(i,j);
                blue(i,j) = (I(i-1,j)+I(i+1,j))/2;
                red(i,j) = (I(i,j-1)+I(i,j+1))/2;
            end
        else
            if(mod(j,2)==0)                         % odd row even column

                % green pixel
                green(i,j) = I(i,j);
                red(i,j) = (I(i-1,j)+I(i+1,j))/2;
                blue(i,j) = (I(i,j-1)+I(i,j+1))/2;

            else                                    % odd row odd column

                % blue pixel
                blue(i,j) = I(i,j);
                green(i,j) = (I(i-1,j)+I(i+1,j)+I(i,j-1)+I(i,j+1))/4;
                red(i,j) = (I(i-1,j-1)+I(i+1,j+1)+I(i-1,j+1)+I(i+1,j-1))/4;
            end
        end
    end
end

border_rows = [1,y];                                % index of border rows
border_columns = [1,x];                             % index of border columns

% interpolation in border rows
for i=1:length(border_rows)
    for j=1:x
        if(border_rows(i) == 1)                     % row 1
            if(mod(j,2)==0)                         % row 1, even column
                green(i,j) = I(i,j);
                red(i,j) = (I(y,j)+I(i+1,j))/2;
                if(j == x)
                    blue(i,j) = (I(i,1)+I(i,j-1));
                else
                    blue(i,j) = (I(i,j-1)+I(i,j+1))/2;
                end

            else                                    % row 1, odd column
                blue(i,j) = I(i,j);
                if(j==1)
                    green(i,j) = (I(y,j)+I(i,x)+I(i,j+1)+I(i+1,j))/4;
                    red(i,j) = (I(i+1,j+1)+I(y,j+1)+I(y,x)+I(i+1,x))/4;
                elseif (j==x)
                    green(i,j) = (I(i+1,j)+I(i,j-1)+I(i,x)+I(y,j))/4;
                    red(i,j) = (I(i+1,j-1)+I(i+1,1)+I(y,1)+I(y,j-1))/4;
                else
                    green(i,j) = (I(i,j+1)+I(i,j-1)+I(i+1,j)+I(y,j))/4;
                    red(i,j) = (I(i+1,j+1)+I(i+1,j-1)+I(y,j+1)+I(y,j-1))/4;
                end
            end
        end

        if(border_rows(i) == y)                     % last row
            i_temp = i;
            i = y;
            if(mod(j,2)==0)                         % last row, even column
                red(i,j) = I(i,j);
                green(i,j) = (I(i,j-1)+I(i,j+1)+I(i-1,j)+I(1,j))/4;
                blue(i,j) = (I(i-1,j-1)+I(i-1,j+1)+I(1,j-1)+I(1,j+1))/4;
            else                                    % last row, odd column
                green(i,j) = I(i,j);
                blue(i,j) = (I(i-1,j)+I(1,j))/2;

                if(j==x)
                    red(i,j) = (I(i,j-1)+I(i,1))/2;
                elseif(j==1)
                    red(i,j) = (I(i,j+1)+I(i,x))/2; 
                else
                    red(i,j) = (I(i,j+1)+I(i,j-1))/2;
                end
            end
            i = i_temp;
        end
    end
end


% interpolation in border columnns
    % since there are an odd number of columns, wrapping around is incorrect
    % we hence perform interpolation only using other available pixels

for i=1:y
    for j=1:length(border_columns)
        if(border_columns(j)==1)                    % first column
            if(mod(i,2)==0)                         % first column, even row        
                green(i,j) = I(i,j);
                red(i,j) = I(i,j+1);
                if(i==y)
                    blue(i,j) = (I(i-1,j)+I(1,j))/2;
                else
                    blue(i,j) = (I(i+1,j)+I(i-1,j))/2;
                end
            else                                    % first column, odd row
                blue(i,j) = I(i,j);
                if(i==1)
                    green(i,j) = (I(i,j+1)+I(i+1,j)+I(y,j))/3;
                    red(i,j) = (I(i+1,j+1)+I(y,j+1))/2;
                else
                    green(i,j) = (I(i,j+1)+I(i-1,j)+I(i+1,j))/3;
                    red(i,j) = (I(i+1,j+1)+I(i-1,j+1))/2;
                end
            end
        
        end


        if(border_columns(j)==x)                    % last column
            j_temp = j;
            j = x;
            if(mod(i,2)==0)                         % last column, even row
                green(i,j) = I(i,j);
                red(i,j) = I(i,j-1);
                if(i==y)
                    blue(i,j) = (I(i-1,j)+I(1,j))/2;
                else
                    blue(i,j) = (I(i+1,j)+I(i-1,j))/2;
                end
            else                                    % last column, odd row
                blue(i,j) = I(i,j);
                if(i==1)
                    green(i,j) = (I(i,j-1)+I(i+1,j))/2;
                    red(i,j) = (I(i+1,j-1)+I(y,j-1))/2;
                else
                    green(i,j) = (I(i,j-1)+I(i-1,j)+I(i+1,j))/3;
                    red(i,j) = (I(i-1,j-1)+I(i+1,j-1))/2;
                end
            end
            j=j_temp;
        end
    end
end

% convert channels back to uint8
red = uint8(red*255);
green = uint8(green*255);
blue = uint8(blue*255);

% merge channels in RGB order 
I = cat(3,red,green,blue);

diff = imabsdiff(im2double(I),im2double(I_Matlab));
imshow(diff)
% % imshow(I)
% % display and compare output
% subplot(1,3,1)
% imshow(I_Original);title("Original Image")
% subplot(1,3,2)
% imshow(I_Matlab);title("Using MATLAB Demosaic Function")
% subplot(1,3,3)
% imshow(I);title("Using Bilinear Interpolation Algorithm")
