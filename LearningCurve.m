function varargout = LearningCurve(varargin)
% LEARNINGCURVE MATLAB code for LearningCurve.fig
%      LEARNINGCURVE, by itself, creates a new LEARNINGCURVE or raises the existing
%      singleton*.
%
%      H = LEARNINGCURVE returns the handle to a new LEARNINGCURVE or the handle to
%      the existing singleton*.
%
%      LEARNINGCURVE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LEARNINGCURVE.M with the given input arguments.
%
%      LEARNINGCURVE('Property','Value',...) creates a new LEARNINGCURVE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LearningCurve_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LearningCurve_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LearningCurve

% Last Modified by GUIDE v2.5 19-Feb-2015 17:36:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LearningCurve_OpeningFcn, ...
                   'gui_OutputFcn',  @LearningCurve_OutputFcn, ...
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


% --- Executes just before LearningCurve is made visible.
function LearningCurve_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LearningCurve (see VARARGIN)

% Choose default command line output for LearningCurve
handles.output = hObject;
% Define uitable store information
handles.UItableData =    {'untitled' '' '' '' '' '' '' '';};
set(handles.uitable_Result, 'Data', handles.UItableData);
handles.CurrentVar = evalin('base','who');
if ~isempty(handles.CurrentVar)
    set(handles.popupmenu_XData, 'String', handles.CurrentVar);
    set(handles.popupmenu_YData, 'String', handles.CurrentVar);
end
% Set step size
handles.StepSize = 50;
% Set the begining training sample
handles.InitialTraningSample = 50;
% Set the current cutoff
handles.CurrentCutoff = 50;
% Set limit of axes
handles.xlimit_top = handles.CurrentCutoff * handles.StepSize * 2;
% Set the testing set size
handles.TestingSetSize = 300;
% Set current algorithm data
handles.Perf_LDA = [];
handles.Perf_SVM = [];
% Set current prefered algorithm
handles.Pref_Alg = [];
% Set the simulated trigger
handles.Simulated = true;
% Set the fold size
handles.n_fold = 10;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LearningCurve wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LearningCurve_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Start_Training_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_TrainingAlgorithm.
function popupmenu_TrainingAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_TrainingAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_TrainingAlgorithm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_TrainingAlgorithm


% --- Executes during object creation, after setting all properties.
function popupmenu_TrainingAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_TrainingAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_FittingAlgorithm.
function popupmenu_FittingAlgorithm_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_FittingAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_FittingAlgorithm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_FittingAlgorithm
StatusString = ['Selected algorithm: ' getCurrentPopupString(handles.popupmenu_FittingAlgorithm)];
% selected algorithm and print the status
set(handles.text_Status, 'string', StatusString);
% abandom code here 02/20/2015
% hard code current data size
handles.current_data = handles.CurrentCutoff/handles.StepSize;
[~, handles] = InstantPlot(handles, handles.Simulated);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_FittingAlgorithm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_FittingAlgorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_FitCurve.
function pushbutton_FitCurve_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FitCurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_FitCurve
StatusString = 'Start parsing...';
% selected algorithm and print the status
set(handles.text_Status, 'string', StatusString);
% select data from workspace
X = evalin('base', getCurrentPopupString(handles.popupmenu_XData));
Y = evalin('base', getCurrentPopupString(handles.popupmenu_YData));
% If current cutoff larger than data size
[epoch_x, ~] = size(X);
[epoch_y, ~] = size(Y);
assert(epoch_x == epoch_y, ...
    'Data size incorrect, make sure X is [sample# * feature_dim], Y is [sample# * label_dim]');
assert(handles.InitialTraningSample <= epoch_y-handles.TestingSetSize/handles.StepSize,...
    'Not enough sample for testing.');
% first check the initial sample size samller than the current cut off
while handles.InitialTraningSample < handles.CurrentCutoff
    % Training based on selected algorithm
    % hard code n_fold to 100
    [Az_WS_LDA, Az_WS_SVM] = SimpleAlgorithm(X, Y, handles.n_fold, ...
        handles.InitialTraningSample, handles.TestingSetSize);
    % set current index
    CurrIdx = handles.InitialTraningSample/handles.StepSize;
    handles.Perf_LDA{CurrIdx} = mean(Az_WS_LDA);
    handles.Perf_SVM{CurrIdx} = mean(Az_WS_SVM);
    % increase by one step size for current cutoff
    handles.InitialTraningSample = handles.InitialTraningSample + handles.StepSize;
end
while handles.CurrentCutoff <= size(Y, 1)-handles.TestingSetSize
    % Training based on selected algorithm
    % hard code n_fold to 100
    [Az_WS_LDA, Az_WS_SVM] = SimpleAlgorithm(X, Y, handles.n_fold, ...
        handles.CurrentCutoff, handles.TestingSetSize);
    % set current index
    CurrIdx = handles.CurrentCutoff/handles.StepSize;
    handles.Perf_LDA{CurrIdx} = mean(Az_WS_LDA);
    handles.Perf_SVM{CurrIdx} = mean(Az_WS_SVM);
    % Set current prefered algorithm
    if handles.Perf_LDA{CurrIdx} >= handles.Perf_SVM{CurrIdx}
        handles.Pref_Alg = handles.Perf_LDA;
        % selected algorithm: LDA
        handles.Pref_AlgID = 1;
    else
        handles.Pref_Alg = handles.Perf_SVM;
        % selected algorithm: SVM
        handles.Pref_AlgID = 2;
    end
    % increase by one step size for current cutoff
    handles.CurrentCutoff = handles.CurrentCutoff + handles.StepSize;
end

% check if the auto training check box is checked
if ~get(handles.checkbox_AutoTraining, 'value')
    selected_training_algorithm = get(handles.popupmenu_TrainingAlgorithm,'Value');
    if selected_training_algorithm == 1
        handles.Pref_Alg = handles.Perf_LDA;
        % selected algorithm: LDA
        handles.Pref_AlgID = 1;
    else
        handles.Pref_Alg = handles.Perf_SVM;
        % selected algorithm: SVM
        handles.Pref_AlgID = 2;
    end
end

% hard code current data size
handles.current_data = handles.CurrentCutoff/handles.StepSize - 1;
[~, handles] = InstantPlot(handles, handles.Simulated);

StatusString = 'Finished.';
% selected algorithm and print the status
set(handles.text_Status, 'string', StatusString);
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function text_Result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_StepSize.
function popupmenu_StepSize_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_StepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_StepSize contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_StepSize
handles.StepSize = str2double(getCurrentPopupString(handles.popupmenu_StepSize));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_StepSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_StepSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_YData.
function popupmenu_YData_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_YData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_YData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_YData


% --- Executes during object creation, after setting all properties.
function popupmenu_YData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_YData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_XData.
function popupmenu_XData_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_XData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_XData contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_XData

% --- Executes during object creation, after setting all properties.
function popupmenu_XData_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_XData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Start_Fitting_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Stop_Training_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Training (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Stop_Fitting_Callback(hObject, eventdata, handles)
% hObject    handle to Stop_Fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Train_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_StartTraining_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_StartTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_StartFitting_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_StartFitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_StopTraining_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_StopTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_StopFitting_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_StopFitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Help_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Readme_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Readme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Commonquestion_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Commonquestion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu_Baseline.
function popupmenu_Baseline_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Baseline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Baseline


% --- Executes during object creation, after setting all properties.
function popupmenu_Baseline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Baseline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Menu_Operator_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Operator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Backward_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Backward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% should be greater than the degree of freedom, hard coded here
if handles.current_data > 5
    handles.current_data = handles.current_data - 1;
    [~, handles] = InstantPlot(handles, handles.Simulated);
else
    disp('Not enough data to do curve fitting.');
end

guidata(hObject,handles);


% --------------------------------------------------------------------
function Menu_Forward_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% current pointer should not go over current cutoff
if handles.current_data <= handles.CurrentCutoff - 1
    handles.current_data = handles.current_data + 1;
    [~, handles] = InstantPlot(handles, handles.Simulated);
else
    disp('Reach the end of your training results.');
end

guidata(hObject,handles);


% --- Executes on button press in checkbox_AutoTraining.
function checkbox_AutoTraining_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_AutoTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_AutoTraining
AutoTrainVal = get(hObject, 'value');
if AutoTrainVal == 1
    set(handles.popupmenu_TrainingAlgorithm, 'Enable', 'off');
else
    set(handles.popupmenu_TrainingAlgorithm, 'Enable', 'on');
end
