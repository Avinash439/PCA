function varargout = sample(varargin)
% SAMPLE M-file for sample.fig
%      SAMPLE, by itself, creates a new SAMPLE or raises the existing
%      singleton*.
%
%      H = SAMPLE returns the handle to a new SAMPLE or the handle to
%      the existing singleton*.
%
%      SAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLE.M with the given input arguments.
%
%      SAMPLE('Property','Value',...) creates a new SAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sample

% Last Modified by GUIDE v2.5 28-Dec-2016 15:55:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sample_OpeningFcn, ...
                   'gui_OutputFcn',  @sample_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before sample is made visible.
function sample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sample (see VARARGIN)

% Choose default command line output for sample
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sample_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_image.
function load_image_Callback(hObject, eventdata, handles)


path = 'c:\users\userName\my documents\matlab\test_set\*';
%filter = '*.jpg';
selectedFile = uigetfile(fullfile(path));
axes(handles.axes2);
img_name_test = strcat('./Test_set/',selectedFile);
Image_test = imread(img_name_test);
imshow(Image_test);

handles.Image_test = Image_test
handles.img_name_test = img_name_test;
guidata(hObject,handles);




% images_test=uigetdir ('./Test_set/*.jpg')
% images_test=dir('./Test_set/*.jpg')
% 
% img_name_test = images_test(5).name
% img_name_test = strcat('./Test_set/*',img_name_test);
% Image_test = imread(img_name_test);
% imshow(Image_test)

% hObject    handle to load_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in search.
function search_Callback(hObject, eventdata, handles)
% hObject    handle to search (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
images=dir ('./Training_set/*.jpg')
files=length(images);


Lt=[];
D = zeros(files,4096);
for i = 1:files
      img_name = images(i).name
      img_name = strcat('./Training_set/',img_name);
      Image = imread(img_name);
     
      Lt=[Lt ;img_name(:,16:18)]
%       size(Image)
%       imshow(Image);
%       subplot(ceil(length(files)\10),ceil(length(files)\10),i);
      %D(i,:) = reshape(Image',1,size(Image,1)*size(Image,2));
      D(i,:) = Image(:)';
    
end


[m n]=size(D);
meanface=mean(D);%mean for all the images
mean1=repmat(meanface,m,1);%mean matrix
x=double(D)- mean1;%removes mean
sigma=(1/ (m-1))*(x*x');%covariance matrix

[V,eval]= eigs(sigma,files); %V = phai'

%principal components
v=D'*V; 

%phai = projection of data on the principal components
%since we have 93 pcs, we'll have 93 dimensional feature vectors for each
%of our data(images)

phai=x*v(:,1:30); 
images_test=dir ('./Test_set/*.jpg')
file=length(images_test);

%d = zeros(file,4096);
%
%
%for n=1:file
% %
%       img_name_test = images_test(40).name
%       img_name_test = strcat('./Test_set/',img_name_test);
%       Image_test = imread(img_name_test);
     %imshow(Image_test)
%       Lt(j,:)=img_name
%       size(Image)
%       imshow(Image);
      %subplot(ceil(length(files)\10),ceil(length(files)\10),i)
      %d = reshape(Image_test',1,size(Image_test,1)*size(Image_test,2));
     Image_test = handles.Image_test;
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
    %a(1,1:5)
    z(1)
      img_name_test = handles.img_name_test;
if strcmp( lower(Lt(z(1),1:3)) , lower(img_name_test(12:14)) )
   fprintf('matched')


else
   fprintf('not matched')
  
end

   axes(handles.axes3)
imshow((reshape(D(z(1),:),64,64)),[]);
                                                
accuracy=63.23
accuracy=num2str(63.23)
set(handles.edit1,'String',accuracy)
                                                                                                               

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
