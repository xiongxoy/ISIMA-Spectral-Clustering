function varargout = globegui(varargin)
% GLOBEGUI M-file for globegui.fig created with GUIDE
%
%      Creates a GUI for viewing a spinning Earth globe
%
%      GLOBEGUI, by itself, creates a new GLOBEGUI or raises the existing
%      one.
%
%      H = GLOBEGUI returns the handle to a new GLOBEGUI or the handle to
%      the existing one.
%
%      GLOBEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLOBEGUI.M with the given input arguments.
%
%      GLOBEGUI('Property','Value',...) creates a new GLOBEGUI or raises the
%      existing one. Starting from the left, property value pairs are
%      applied to the GUI before globegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to globegui_OpeningFcn via varargin.
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Last Modified by GUIDE v2.5 10-Mar-2008 09:50:13

%   Copyright 2008 The MathWorks, Inc.

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @globegui_OpeningFcn, ...
                   'gui_OutputFcn',  @globegui_OutputFcn, ...
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


% --- Executes just before globegui is made visible.
function globegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to globegui (see VARARGIN)

% Check whether initialization has been done in case this GUI
% is a singleton and has already been opened.
% if isfield(handles,'running')
%     disp('No initialization this time.')
% else
%     handles.running = true;
%     guidata(hObject,handles)
%     disp('Initializing...')
% end

% Choose default command line output for globegui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes globegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = globegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in spinstopbutton.
function spinstopbutton_Callback(hObject, eventdata, handles)
% Spins the globe in the axes or stops it, renaming the button
% from "Spin" to "Stop" and back again. When its label is "Stop"
% this callback is executing an endless loop and is re-entered; 
% thus it must have properties set as follows (which is the
% default behavior of a GUIDE GUI):
%  Interruptible: 'on', BusyAction: 'queue'
%
% hObject    handle to spinstopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(hObject,'String');    % get the current pushbutton string 
% Determine which string the label matches 
state = find(strcmp(str,handles.Strings)); 
% Toggle the button label to other string 
set(hObject,'String',handles.Strings{3-state}); 
% If the index when entering was 1, start to spin the object
if (state == 1)
 %   globe = struct;
    filming = handles.movie;
    az = handles.azimuth;
    hgrotate = handles.tform;
    % Spin globe as long as the figure exists or until user
    %  interrupts by pressing the button a second time
    while ishandle(handles.axes1)
        % If button label changed since last iteration, stop now
        if find(strcmp(get(hObject,'String'),...
                handles.Strings)) == 1
            % Save rotation state to restart at this orientation
            handles.azimuth = az;
            guidata(hObject,handles);
            break
        end
        az = az + 0.01745329252; % Increment azimuth (in radians)
                                 % to rotate east one degree
        % Modify the hgtransform controling the two surface objects
        set(hgrotate,'Matrix',makehgtform('zrotate',az));
        drawnow                  % Refresh the screen
        % If the Make movie button is checked, save frames
        %   but don't store more than one revolution
        %  NOTE: filming slows down the animation
        % Need to test whether axes exists because user can quit
        % during filming, destroying axes and figure
        if ishandle(handles.axes1) && filming > 0 && filming < 361
            globeframes(filming) = getframe(handles.axes1);
            filming = filming + 1;
        end
    end
    % Write captured frames to MAT-file if in movie mode
    if (filming)
        filename = sprintf('globe%i.mat',filming-1);
        disp(['Writing movie to file ' filename]);
        save (filename, 'globeframes')
    end
 end


% --- Executes on button press in quitbutton.
function quitbutton_Callback(hObject, eventdata, handles)
% hObject    handle to quitbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles = guidata(hObject);

% Get the figure's handle, then destroy it
fig = handles.figure1;
close(fig)


% --- Executes during object creation, after setting all properties.
function spinstopbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spinstopbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - not created until after all CreateFcns called
% Creates the handles structure and places into it label strings
%  to test button's current name against
handles.Strings = {'Spin';'Stop'}; 
% Commit the new struct element to appdata
guidata(hObject, handles); 


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% Generate a colormap appropriate for terrain display
cmap =  [0         0    0.2000;         0         0    0.2471;...
         0         0    0.2941;         0         0    0.3412;...
         0         0    0.3882;         0         0    0.4353;...
         0         0    0.4824;         0         0    0.5294;...
         0         0    0.5765;         0         0    0.6235;...
         0         0    0.6706;         0         0    0.7176;...
         0         0    0.7647;         0         0    0.8118;...
         0         0    0.8588;         0         0    0.9059;...
         0         0    0.9529;         0         0    1.0000;...
         0    0.0556    1.0000;         0    0.1111    1.0000;...
         0    0.1667    1.0000;         0    0.2222    1.0000;...
         0    0.2778    1.0000;         0    0.3333    1.0000;...
         0    0.3889    1.0000;         0    0.4444    1.0000;...
         0    0.5000    1.0000;         0    0.5556    1.0000;...
         0    0.6111    1.0000;         0    0.6667    1.0000;...
         0    0.7222    1.0000;         0    0.7778    1.0000;...
         0    0.8333    1.0000;         0    0.8889    1.0000;...
         0    0.9444    1.0000;         0    1.0000    1.0000;...
         0    0.4000    0.2000;    0.0253    0.4429    0.2043;...
    0.0555    0.4857    0.2092;    0.0906    0.5286    0.2157;...
    0.1306    0.5714    0.2251;    0.1755    0.6143    0.2382;...
    0.2253    0.6571    0.2562;    0.2800    0.7000    0.2800;...
    0.3684    0.7429    0.3396;    0.4586    0.7857    0.4041;...
    0.5496    0.8286    0.4735;    0.6402    0.8714    0.5478;...
    0.7296    0.9143    0.6269;    0.8165    0.9571    0.7110;...
    0.9000    1.0000    0.8000;    0.8499    0.9538    0.7044;...
    0.8099    0.9077    0.6144;    0.7787    0.8615    0.5302;...
    0.7548    0.8154    0.4516;    0.7367    0.7692    0.3787;...
    0.7231    0.7231    0.3115;    0.6769    0.6413    0.2499;...
    0.6308    0.5580    0.1941;    0.5846    0.4744    0.1439;...
    0.5385    0.3921    0.0994;    0.4923    0.3124    0.0606;...
    0.4462    0.2368    0.0275;    0.4000    0.1667         0];

load topo                       % Get 1x1 degree terrain grid
% Make axes a slightly oversized unit box centered on 0,0,0
set(hObject,'xlim',[-1.02 1.02],...
            'ylim',[-1.02 1.02],...
            'zlim',[-1.02 1.02]);
% Create a spherical structure
[x,y,z] = sphere(50);
hgttilt = hgtransform;
hgrotate = hgtransform('parent',hgttilt);
% Set display properties
props.FaceColor= 'texture';
props.EdgeColor = 'none';
props.FaceLighting = 'gouraud';
props.Cdata = topo;             % Use topo grid as a texturemap
props.Parent = hgrotate;              % Make hgtransform surface parent
hsurf = surface(x,y,z,props);   % Draw 3-D view
colormap(cmap)      % Use special terrain colormap defined above

% Rotate the surface by 23.44 deg (0.4091 radians) around x-axis;
%   this is the earth's tilt from normal to the ecliptic.
%   To learn about geometric operations, type "doc hgtransform".
set(hgttilt,'Matrix',makehgtform('xrotate',0.4091));

% Create another mesh to be the graticule
[gx,gy,gz] = sphere(15);
% Decimate every other row to make mesh elements square
for j = 2:9
    gx(j,:) = [];
    gy(j,:) = [];
    gz(j,:) = [];
end
% Expand mesh slightly so it lies above the topo surface
gx = gx * 1.02;
gy = gy * 1.02;
gz = gz * 1.02;

% Draw the surface as a plain mesh with no face shading
hmesh = mesh(gx,gy,gz,'parent',hgrotate,...
        'FaceColor','none','EdgeColor',[.5 .5 .5]);
set(hmesh,'Visible','off')      % Hide the graticule until turned on
hlight = camlight(0,0);       % Create a light source at middle left
% Cache object handles and params for later use
handles.light = hlight;
handles.tform = hgrotate;
handles.hmesh = hmesh;
handles.azimuth = 0.;
handles.cmap = cmap;
guidata(gcf,handles);           % Save handles structure


function sunazslider_Callback(hObject, eventdata, handles)
% Changes azimuth of light source, maintaining its elevation
% hObject    handle to sunazslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') 
%                           to determine range of slider

hlight = handles.light;         % Get handle to light object
% Rotate the light with the view
sunel = get(handles.sunelslider,'value'); % Get current light elev.
sunaz = get(hObject,'value');   % Varies from -180 -> 0 deg
lightangle(hlight,sunaz,sunel)


% --- Executes during object creation, after setting all properties.
function sunazslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sunazslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), ...
           get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function sunelslider_Callback(hObject, eventdata, handles)
% Changes elevation of light source, maintaining its azimuth
% hObject    handle to sunelslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max')
%                           to determine range of slider

hlight = handles.light;         % Get handle to light object
sunaz = get(handles.sunazslider,'value'); % Get current light azim.
sunel = get(hObject,'value');   % Varies from -72.8 -> 72.8 deg
lightangle(hlight,sunaz,sunel)

% --- Executes during object creation, after setting all properties.
function sunelslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sunelslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), ...
           get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in showgridbutton.
function showgridbutton_Callback(hObject, eventdata, handles)
% hObject    handle to showgridbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showgridbutton

if get(hObject,'Value')
    set(handles.hmesh,'Visible','on')
else
    set(handles.hmesh,'Visible','off')
end


% --- Executes on button press in movie_checkbox.
function movie_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to movie_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of movie_checkbox

handles.movie = get(hObject,'Value');
guidata(gcf,handles)


% --- Executes during object creation, after setting all properties.
function movie_checkbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to movie_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - not created until after all CreateFcns called

handles.movie = 0;
set(hObject,'Value',0);
guidata(gcf,handles)
