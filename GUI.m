function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 28-May-2017 14:03:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
data=load('dataset.csv');
data=datasample(data,size(data,1),'Replace',false);
hObject.UserData =data;
axes(handles.axes1);
plot(data(:,1) , data(:,2),'*');

% --- Executes on button press in clear_btn.
function clear_btn_Callback(hObject, eventdata, handles)

cla(handles.axes1,'reset');
cla(handles.axes2,'reset');
cla(handles.axes3,'reset');
cla(handles.axes4,'reset');
cla(handles.axes5,'reset');
cla(handles.axes6,'reset');

% handles.hidden_layer_w_label.String='';
% handles.output_layer_w_label.String='';
handles.nmi_label.String='0';
handles.rand_index_label.String='0';
% % cla(handles.axes_weights,'reset');
% 
% 
% handles.figure1.HandleVisibility='off';
% close all;
% handles.figure1.HandleVisibility='on';
clc;


% --- Executes on button press in batch_mode.
function batch_mode_Callback(hObject, eventdata, handles)
% hObject    handle to batch_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of batch_mode


% --- Executes on button press in rec_mode.
function rec_mode_Callback(hObject, eventdata, handles)
% hObject    handle to rec_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rec_mode



function neuron_number_Callback(hObject, eventdata, handles)
% hObject    handle to neuron_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuron_number as text
%        str2double(get(hObject,'String')) returns contents of neuron_number as a double


% --- Executes during object creation, after setting all properties.
function neuron_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuron_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function neuron_number_y_Callback(hObject, eventdata, handles)
% hObject    handle to neuron_number_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of neuron_number_y as text
%        str2double(get(hObject,'String')) returns contents of neuron_number_y as a double


% --- Executes during object creation, after setting all properties.
function neuron_number_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to neuron_number_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in som_btn.
function som_btn_Callback(hObject, eventdata, handles)
if(handles.exp_dist.Value==1)
    neighborhood='exp';
elseif(handles.gaussy_dist.Value==1)
    neighborhood='gaussy';
    
elseif(handles.gaussy_dist.Value==1)
    neighborhood='gaussy';
elseif(handles.const_dist.Value==1)
    neighborhood='const';
elseif(handles.rect_dist.Value==1)
    neighborhood='radius';
end
learning_mode='rec';
if(handles.batch_mode.Value==1)
    learning_mode='batch';
end
neuron_number=handles.neuron_number.String;
arch_neuron=str2double(strsplit(neuron_number,','));
threshold=str2double( handles.max_iteration.String);
tr_data=handles.load_btn.UserData;
SOM(tr_data,arch_neuron,threshold,learning_mode,neighborhood,handles);



function max_iteration_Callback(hObject, eventdata, handles)
% hObject    handle to max_iteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_iteration as text
%        str2double(get(hObject,'String')) returns contents of max_iteration as a double


% --- Executes during object creation, after setting all properties.
function max_iteration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_iteration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function batch_size_Callback(hObject, eventdata, handles)
% hObject    handle to batch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of batch_size as text
%        str2double(get(hObject,'String')) returns contents of batch_size as a double


% --- Executes during object creation, after setting all properties.
function batch_size_CreateFcn(hObject, eventdata, handles)
% hObject    handle to batch_size (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gsom_btn.
function gsom_btn_Callback(hObject, eventdata, handles)
max_it_threshold=str2double( handles.max_iteration.String);
my_alpha=str2double( handles.alpha.String);
my_gamma=str2double( handles.gamma.String);
spread_factor=str2double( handles.spread_factor.String);

dataset=handles.load_btn.UserData;
X=dataset(:,1:2);
for i=1:size(X,2)
    X(:,i)=(X(:,i)- min(X(:,i))) / (max(X(:,i))-min(X(:,i)));
end
gsom_net=GSOM(X, spread_factor,max_it_threshold,my_alpha,my_gamma,handles);
train(gsom_net);

for pp=1:length(gsom_net.nodes)
    nnn=gsom_net.nodes(pp);
    weights(pp,:)=nnn.weights;
end
%%%clustering
z=linkage(weights,'ward');
res = cluster(z,'maxclust',5);
cluster_centers=zeros(5,2);
for j=1:5
    cluster_centers(j,:)= mean(weights(res==j,:));
end

%%%labeling
labels=zeros(length(X),1);
for j=1:length(X)
    dist=zeros(5,1);
    for p=1:5
        dist(p)=norm(cluster_centers(p,:)-X(j,:));
    end
    [~,labels(j)]=min(dist);
end
my_nmi=NMI(labels,dataset(:,3));
rand_index=RandIndex(labels,dataset(:,3));
handles.nmi_label.String=num2str(my_nmi);
handles.rand_index_label.String=num2str(rand_index);
        



axes(handles.axes2);
plot(gsom_net.learning_rates,'-r','MarkerSize',1);
title('Learning rate');
xlabel('#epoch');
ylabel('LR');

axes(handles.axes3);
plot(gsom_net.neurons_numbers,'-r','MarkerSize',1);
title('Neurons number');
xlabel('#epoch');
ylabel('#neurons');

axes(handles.axes4);
plot(X(:,1) , X(:,2),'Og','MarkerFaceColor','g','MarkerSize',1.5);


hold on 
for i=1:length(res)
    hold on
    switch res(i)
        case 1
            plot(weights(i,1),weights(i,2),'Or');
        case 2
            plot(weights(i,1),weights(i,2),'Ob');
        case 3
            plot(weights(i,1),weights(i,2),'Om');
        case 4
            plot(weights(i,1),weights(i,2),'Oc');
        case 5
            plot(weights(i,1),weights(i,2),'Ok');
     end
end
legend('data','neurons');




function spread_factor_Callback(hObject, eventdata, handles)
% hObject    handle to spread_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spread_factor as text
%        str2double(get(hObject,'String')) returns contents of spread_factor as a double


% --- Executes during object creation, after setting all properties.
function spread_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spread_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma_Callback(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma as text
%        str2double(get(hObject,'String')) returns contents of gamma as a double


% --- Executes during object creation, after setting all properties.
function gamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha_Callback(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha as text
%        str2double(get(hObject,'String')) returns contents of alpha as a double


% --- Executes during object creation, after setting all properties.
function alpha_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
