function varargout = Project(varargin)
% PROJECT MATLAB code for Project.fig
%      PROJECT, by itself, creates a new PROJECT or raises the existing
%      singleton*.
%
%      H = PROJECT returns the handle to a new PROJECT or the handle to
%      the existing singleton*.
%
%      PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT.M with the given input arguments.
%
%      PROJECT('Property','Value',...) creates a new PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project

% Last Modified by GUIDE v2.5 10-Jan-2021 04:54:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project_OpeningFcn, ...
                   'gui_OutputFcn',  @Project_OutputFcn, ...
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

% --- Executes just before Project is made visible.
function Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project (see VARARGIN)
clc;
global first;
global flag;
flag=0;
first=0;

% Choose default command line output for Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Sec_Callback(hObject, eventdata, handles)
% hObject    handle to Sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Sec as text
%        str2double(get(hObject,'String')) returns contents of Sec as a double


% --- Executes during object creation, after setting all properties.
function Sec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Imp.
function Imp_Callback(hObject, eventdata, handles)
% hObject    handle to Imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flag;
global filename;
global filepath;
flag=1;
[filename, filepath] = uigetfile({'*.*';'*.wav';'*.mp3'}, 'Choose a song to play');


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global first;
global flag;
global filename;
global filepath;
global p1;
global p2;
global y;
global t;
global fs;
global t_channel;
global y_channel;
global N_sec;
first=first+1;
if(flag~=1)
    [song,fs] = audioread('song.MP3');
else
    [song,fs] = audioread(fullfile(filepath, filename));
end
if(isnan(str2double(get(handles.Sec,'string')))==1)
    N_sec = 8;
else
    N_sec = str2double(get(handles.Sec,'string'));
end
t = linspace(0,N_sec,N_sec*fs);
y = song(1:N_sec*fs);
axes(handles.Time);
if(first>1)
    delete(p1);
end
p1 = plot(t,y);
N_samples = length(y);
y_freq = abs(fftshift(fft(y)));
f_vec = linspace(-fs/2,fs/2,N_samples);
axes(handles.Freq);
if(first>1)
    delete(p2);
end
p2 = plot(f_vec,y_freq);
clear sound;
sound(y,fs);
flag=0;
t_channel=t;
y_channel = y;

set(handles.text11, 'String', 'Time Domain');
set(handles.text12, 'String', 'Frequency Domain');

set(handles.Delta ,'enable' ,'on');
set(handles.exp1 ,'enable' ,'on');
set(handles.exp2 ,'enable' ,'on');
set(handles.S_imp ,'enable' ,'on');
set(handles.Nimp ,'enable' ,'on');
set(handles.next ,'enable' ,'on');
set(handles.Imp ,'enable' ,'off');
set(handles.Sec ,'enable' ,'off');
set(handles.play ,'enable' ,'off');

% --- Executes on button press in Delta.
function Delta_Callback(hObject, eventdata, handles)
% hObject    handle to Delta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y;
global fs;
global t_channel;
global y_channel;
global p1;
global p2;
global t;
global N_sec;

if(isnan(str2double(get(handles.Nimp,'string')))==1)
    t_imp = 1;
else
    t_imp = str2double(get(handles.Nimp,'string'));
end
t_channel=linspace(0,N_sec+t_imp,(N_sec+t_imp)*fs-1);
delta=[1 zeros(1,t_imp*fs-1)];
y_channel=conv(y,delta);
axes(handles.Time);
delete(p1);
p1 = plot(t,y);
set(handles.text11, 'String', 'Signal before impulse respone');
axes(handles.Freq);
delete(p2);
p2 = plot(t_channel,y_channel);
set(handles.text12, 'String', 'Signal after impulse respone');
clear sound;
sound(y_channel,fs);

% --- Executes on button press in exp1.
function exp1_Callback(hObject, eventdata, handles)
% hObject    handle to exp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y;
global fs;
global t_channel;
global y_channel;
global p1;
global p2;
global t;
global N_sec;

if(isnan(str2double(get(handles.Nimp,'string')))==1)
    t_imp = 1;
else
    t_imp = str2double(get(handles.Nimp,'string'));
end
t_conv=linspace(0,t_imp,t_imp*fs);
t_channel=linspace(0,N_sec+t_imp,(N_sec+t_imp)*fs-1);
exp1=exp(-2*pi*5000*t_conv); 
y_channel=conv(y,exp1);
axes(handles.Time);
delete(p1);
p1 = plot(t,y);
set(handles.text11, 'String', 'Signal before impulse respone');
axes(handles.Freq);
delete(p2);
p2 = plot(t_channel,y_channel);
set(handles.text12, 'String', 'Signal after impulse respone');
clear sound;
sound(y_channel,fs);


% --- Executes on button press in exp2.
function exp2_Callback(hObject, eventdata, handles)
% hObject    handle to exp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y;
global fs;
global t_channel;
global y_channel;
global p1;
global p2;
global t;
global N_sec;

if(isnan(str2double(get(handles.Nimp,'string')))==1)
    t_imp = 1;
else
    t_imp = str2double(get(handles.Nimp,'string'));
end
t_conv=linspace(0,t_imp,t_imp*fs);
t_channel=linspace(0,N_sec+t_imp,(N_sec+t_imp)*fs-1);
exp2=exp(-2*pi*1000*t_conv); 
y_channel=conv(y,exp2);
axes(handles.Time);
delete(p1);
p1 = plot(t,y);
set(handles.text11, 'String', 'Signal before impulse respone');
axes(handles.Freq);
delete(p2);
p2 = plot(t_channel,y_channel);
set(handles.text12, 'String', 'Signal after impulse respone');
clear sound;
sound(y_channel,fs);


% --- Executes on button press in S_imp.
function S_imp_Callback(hObject, eventdata, handles)
% hObject    handle to S_imp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y;
global fs;
global t_channel;
global y_channel;
global p1;
global p2;
global t;
global N_sec;

if(isnan(str2double(get(handles.Nimp,'string')))==1)
    t_imp = 1;
else
    t_imp = str2double(get(handles.Nimp,'string'));
end
t_channel=linspace(0,N_sec+t_imp,(N_sec+t_imp)*fs-1);
delta2=[2 zeros(1,t_imp*fs-2) 0.5];
y_channel=conv(y,delta2);
axes(handles.Time);
delete(p1);
p1 = plot(t,y);
set(handles.text11, 'String', 'Signal before impulse respone');
axes(handles.Freq);
delete(p2);
p2 = plot(t_channel,y_channel);
set(handles.text12, 'String', 'Signal after impulse respone');
clear sound;
sound(y_channel,fs);

% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.noise ,'enable' ,'on');
set(handles.sigma ,'enable' ,'on');

set(handles.Delta ,'enable' ,'off');
set(handles.exp1 ,'enable' ,'off');
set(handles.exp2 ,'enable' ,'off');
set(handles.S_imp ,'enable' ,'off');
set(handles.Nimp ,'enable' ,'off');
set(handles.next ,'enable' ,'off');



function sigma_Callback(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigma as text
%        str2double(get(hObject,'String')) returns contents of sigma as a double


% --- Executes during object creation, after setting all properties.
function sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in noise.
function noise_Callback(hObject, eventdata, handles)
% hObject    handle to noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_channel;
global y_channel;
global p1;
global p2;
global fs;
global y_freq;
global fvec;
if(isnan(str2double(get(handles.sigma,'string')))==1)
    Sigma = 0.05;
else
    Sigma = str2double(get(handles.sigma,'string'));
end
Z=Sigma*randn(1,length(y_channel));           
y_noise=y_channel+Z;
clear sound;
sound(y_noise,fs);
axes(handles.Time);
delete(p1);
p1 = plot(t_channel,y_noise);
set(handles.text11, 'String', 'Time Domain');
N2=length(y_noise);                        
fvec=linspace(-fs/2,fs/2,N2);               
y_freq=(fftshift(fft(y_noise)));
axes(handles.Freq);
delete(p2);
y_plot=abs(y_freq);
p2 = plot(fvec,y_plot);
set(handles.text12, 'String', 'Frequency Domain');

set(handles.c_freq ,'enable' ,'on');
set(handles.filter ,'enable' ,'on');

function c_freq_Callback(hObject, eventdata, handles)
% hObject    handle to c_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c_freq as text
%        str2double(get(hObject,'String')) returns contents of c_freq as a double


% --- Executes during object creation, after setting all properties.
function c_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs;
global y_freq;
global p1;
global p2;
global fvec;
global t_channel;

spH=length(y_freq)/fs; 
if(isnan(str2double(get(handles.c_freq,'string')))==1)
    frequency = 3400;
else
    frequency = str2double(get(handles.c_freq,'string'));
end
f_cut=uint32(((fs/2)-frequency)*spH);                    
y_freq([1:f_cut end-f_cut+1:end])=0;
y_filter=real(ifft(ifftshift(y_freq)));

clear sound;
sound(y_filter,fs);
axes(handles.Time);
delete(p1);
p1 = plot(t_channel,y_filter);
set(handles.text11, 'String', 'Time Domain');                                      
axes(handles.Freq);
delete(p2);
y_plot=abs(y_freq);
p2 = plot(fvec,y_plot);
set(handles.text12, 'String', 'Frequency Domain');

set(handles.cmp ,'enable' ,'on');



% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear sound;
close all;


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.noise ,'enable' ,'off');
set(handles.sigma ,'enable' ,'off');
set(handles.Delta ,'enable' ,'off');
set(handles.exp1 ,'enable' ,'off');
set(handles.exp2 ,'enable' ,'off');
set(handles.S_imp ,'enable' ,'off');
set(handles.next ,'enable' ,'off');
set(handles.c_freq ,'enable' ,'off');
set(handles.filter ,'enable' ,'off');
set(handles.cmp ,'enable' ,'off');

set(handles.Imp ,'enable' ,'on');
set(handles.Sec ,'enable' ,'on');
set(handles.play ,'enable' ,'on');


% --- Executes on button press in cmp.
function cmp_Callback(hObject, eventdata, handles)
% hObject    handle to cmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global t_channel;
global y_channel;
global p2;

set(handles.text11, 'String', 'Signal after filtering');                                      
axes(handles.Freq);
delete(p2);
p2 = plot(t_channel,y_channel);
set(handles.text12, 'String', 'Signal before adding noise');



function Nimp_Callback(hObject, eventdata, handles)
% hObject    handle to Nimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nimp as text
%        str2double(get(hObject,'String')) returns contents of Nimp as a double


% --- Executes during object creation, after setting all properties.
function Nimp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nimp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
