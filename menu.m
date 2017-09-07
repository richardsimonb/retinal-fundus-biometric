function varargout = menu(varargin)
% BIOMETRIC_PROGRAM MATLAB code for Biometric_program.fig
%      BIOMETRIC_PROGRAM, by itself, creates a new BIOMETRIC_PROGRAM or raises the existing
%      singleton*.
%
%      H = BIOMETRIC_PROGRAM returns the handle to a new BIOMETRIC_PROGRAM or the handle to
%      the existing singleton*.
%
%      BIOMETRIC_PROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BIOMETRIC_PROGRAM.M with the given input arguments.
%
%      BIOMETRIC_PROGRAM('Property','Value',...) creates a new BIOMETRIC_PROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Biometric_program_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Biometric_program_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Biometric_program

% Last Modified by GUIDE v2.5 28-Jun-2017 15:15:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Biometric_program_OpeningFcn, ...
                   'gui_OutputFcn',  @Biometric_program_OutputFcn, ...
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


% --- Executes just before Biometric_program is made visible.
function Biometric_program_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Biometric_program (see VARARGIN)

% Choose default command line output for Biometric_program
handles.output = hObject;




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Biometric_program wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Biometric_program_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    program_data = guidata(gcbo);
    
    [basefilename,path]= uigetfile({'*.tif';'*.jpeg';'*.jpg';'*.ppm'},...
        'Open Image File');
    filename = fullfile(path, basefilename);
    I = imread (filename);
    citra = I;

    axes(handles.citra);
    imshow(citra);
    set(program_data.citra,'Userdata',I);
    set(program_data.nama_citra,'String', basefilename);
    set(program_data.nama_citra,'Userdata', filename);
    


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    program_data = guidata(gcbo);
    
    citra = segmentation_v2(get(program_data.citra,'Userdata'));
    axes(handles.citra);
    imshow(citra);
    set(program_data.citra,'Userdata',citra);
   
    
    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    program_data = guidata(gcbo);
    
    [basefilename,path]= uiputfile({'*.png',...
        'Portable Network Graphics'},'Save Image');
    imwrite(get(program_data.citra,'Userdata'),...
        fullfile(path, basefilename));
    
    
    


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    program_data = guidata(gcbo);
    datasetfolder = uigetdir;
    
    set(program_data.info_text,'String', strcat('Dataset Location : '...
        ,datasetfolder));
    set(program_data.info_text,'Userdata', datasetfolder);
    


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    myFolder = 'D:\Thesis\BiometricProgram\Dataset\vessel\';
    if ~isdir(myFolder)
        errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
        uiwait(warndlg(errorMessage));
    return;
    end
    filePattern = fullfile(myFolder, '*.png');
    imageFiles = dir(filePattern);
    feat = [];

    for k = 1:length(imageFiles)
        baseFileName = imageFiles(k).name;
        fullFileName = fullfile(myFolder, baseFileName);
        fprintf(1, 'Now reading %s\n', fullFileName);
        imageArray = imread(fullFileName);
        scale_img = imresize(imageArray,0.5);
        scale_vec = reshape(scale_img,[],1);
        feat = horzcat(feat,scale_vec);
        %scaledarr{1,k} = scale_img;
        %imshow(scale_img);  % Display image.
        %drawnow; % Force display to update immediately.
    end

    target = [1 0 0 0 0 0 0 0 0 0;
              0 1 0 0 0 0 0 0 0 0;
              0 0 1 0 0 0 0 0 0 0;
              0 0 0 1 0 0 0 0 0 0;
              0 0 0 0 1 0 0 0 0 0;
              0 0 0 0 0 1 0 0 0 0;
              0 0 0 0 0 0 1 0 0 0;
              0 0 0 0 0 0 0 1 0 0;
              0 0 0 0 0 0 0 0 1 0;
              0 0 0 0 0 0 0 0 0 1]

    save 'D:\Thesis\BiometricProgram\GUI\data.mat' feat target;


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load D:\Thesis\BiometricProgram\data.mat;

inputs = feat;
targets = target;

hiddenLayerSize = 16;
net = patternnet(hiddenLayerSize);

%net.divideParam.trainRatio = 80/100;
%net.divideParam.valRatio = 10/100;
%net.divideParam.testRatio = 10/100;

[net,tr] = train(net,inputs,targets);

outputs = net(inputs);
figure;plotconfusion(target,outputs);

%errors = gsubtract(targets,outputs);
%performance = perform(net,targets,outputs)
%view(net)