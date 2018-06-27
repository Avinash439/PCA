clc;
clear all;
close all;
images=dir ('./Training_set/*.jpg') %path for the training set
files=length(images);


Lt=[];
D = zeros(files,4096);
for i = 1:files
      img_name = images(i).name
      img_name = strcat('./Training_Set/',img_name);%string concatenation with the image name
      Image = imread(img_name);
      
       Lt=[Lt ;img_name(:,16:18)]%label matrix of training set
%       size(Image)
%       imshow(Image);
%       subplot(ceil(length(files)\10),ceil(length(files)\10),i);
     % D(i,:) = reshape(Image',1,size(Image,1)*size(Image,2));
      D(i,:) = Image(:)';
      
end

%


[m n]=size(D);
meanface=mean(D);%mean for all the images
mean=repmat(meanface,m,1);%mean matrix
x=double(D)- mean;%removes mean
sigma=(1/ (m-1))*(x*x');%covariance matrix

[V,eval]= eigs(sigma,files); %V = phai' eigen values and eigen vectors

%principal components
v=D'*V; 

%phai = projection of data on the principal components
%since we have 93 pcs, we'll have 93 dimensional feature vectors for each
%of our data(images)


phai=x*v(:,1:30); 

% Ft=reshape(phai',1,size(phai,1)*size(phai,2));
    


images_test=dir ('./Test_set/*.jpg')
file=length(images_test);

%d = zeros(file,4096);
%
%
%for n=1:file
%
      img_name_test = images_test(1).name
      img_name_test = strcat('./Test_set/',img_name_test);
      Image_test = imread(img_name_test);
     imshow(Image_test)
%       Lt(j,:)=img_name
%       size(Image)
%       imshow(Image);
      %subplot(ceil(length(files)\10),ceil(length(files)\10),i)
      %d = reshape(Image_test',1,size(Image_test,1)*size(Image_test,2));
      d = Image_test(:)';
      pha=(double(d)- meanface) *v(:,1:30);
 
  

%  ft=reshape(pha',1,size(pha,1)*size(pha,2));


%  Euclidean distance between all test vector and train vector





    for l = 1:files
        %pha is feature vector of test
        dist = pha - phai(l,:);
        distance(l)= sqrt(sum(dist.^2));
    end
    distance;
    
    %sorted distances are in a
    [a z]=sort(distance, 'ascend');
    z(1)
    z(2)
    z(3)
    %a(1,1:5)
    z(1)
if strcmp( lower(Lt(z(1),1:3)) , lower(img_name_test(12:14)) )
   fprintf('matched')

else
   fprintf('not matched')
  
end

%prev: we check if best match is correct match for one test image
%%
images_test = dir ('./Test_set/*.jpg')
file = length(images_test);
%file is the total number of test images
d = zeros(file,4096);

Lts = [];
for n=1:file
%     
      img_name_test = images_test(n).name
      img_name_test = strcat('./Test_set/',img_name_test);
      Image_test = imread(img_name_test);
     imshow(Image_test)
     
      %d = reshape(Image_test',1,size(Image_test,1)*size(Image_test,2));
      d = Image_test(:)';
      pha(n,:)=(double(d)- meanface) *v(:,1:30);
       Lts=[Lts ;img_name_test(:,12:14)];
end
%prev: every test image, we have created 93 dimensional feature vector

%distance2={};
error = 0
for k=1:file %test images
    for l = 1:files%train images
        %pha -> test images feature vector
        dist = pha(k,:)- phai(l,:);
        distance1(l) = sqrt(sum(dist.^2));
        
    end
    %distance1 has distance of test image k from all the train images
    
    [a z]=sort(distance1, 'ascend');
    %a(1,1:5)
    z(1)
    if strcmp( lower(Lt(z(1),1:3)) , lower(Lts(k,:)) )
        fprintf('matched')
        
    else
        fprintf('not matched')
        error=error+1
    end
end

accuracy=(1-error/file)*100   %Accuracy for all the test images    