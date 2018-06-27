clc;
clear all;
close all;
i= xlsread('Dataset_Face_Recognition.xlsx','B2:K151'); %reading the excel sheet

%%

%%
maxiter = 10;
F1 = vec2mat(i(1,:),2);
for j = 1:maxiter  
    F1 = [F1 ones(5,1)];
    
    Fp=[13;50;34;16;48];%predetermined features of x
    x=F1\Fp;
    
    Fp1=[20;20;34;50;50];% predetermined features of y
    y=F1\Fp1;
    
    F=[x,y];%
    %%
    %%
    
    
    A = [F(1),F(2);F(4),F(5)]; %affine parameters
    b = [F(3),F(6)]; %affine parameter
    
    
    Fp1_X = F1*x;
    Fp1_Y = F1*y;
    FP=[Fp1_X,Fp1_Y];
    %%
    
    Acc_X = zeros(size(Fp1_X));
    Acc_Y = zeros(size(Fp1_Y));
    
    maxiter =10;
    %%
    
    for k=1:size(i,1)
        F1 = vec2mat(i(k,:),2);
        F1 = [F1 ones(5,1)];
        
   
        x(:,k)=F1\FP(:,1);
        
       
        y(:,k)=F1\FP(:,2);
        
        F=[x,y];
        
        
      %F1(:,:,k)=F
        
        
        %
        Fp1_X = F1*x(:,k);
        Fp1_Y = F1*y(:,k);
        
        Acc_X = Acc_X + Fp1_X;
        Acc_Y = Acc_Y + Fp1_Y;
    end
    %%
    
    Favg_X = Acc_X/ size(i,1);
    Favg_Y = Acc_Y /size(i,1);
    Favg = [Favg_X,Favg_Y];
    error = max(max(abs(Favg - FP)))
    F1 = Favg
end




images=dir ('./face/*.jpg');
files=length(images);


for m=1:files
%     filename='./faces'
    img_name = images(m).name;
    filename=strcat('./face/',img_name);
    Image = imread(filename);
    Image = rgb2gray(Image);
%     imshow(Image)
    
    temp=[0 0 1]';
    x(:,m);
    y(:,m);
    a = [x(1:2,m) ,y(1:2,m)];
    b = [x(3,m);y(3,m)];
    transform=maketform('affine',[x(:,m) y(:,m) temp]);
    new=imtransform(Image,transform,'XData',[1,64],'YData',[1,64]);
    save=strcat('./New faces/',img_name);
    imwrite(new,save)
end
















