function varargout = UI(varargin)
% UI MATLAB code for UI.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI

% Last Modified by GUIDE v2.5 28-Nov-2015 03:55:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_OutputFcn, ...
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


% --- Executes just before UI is made visible.
function UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI (see VARARGIN)

% Choose default command line output for UI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



%Fonction exécutée lorsqu'on selectione une image dans la boite de liste.
%Affiche l'image
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
get(handles.figure1,'SelectionType');
global image2search % variable global contient le nom de l'image à chercher

% Si double cliquée
if strcmp(get(handles.figure1,'SelectionType'),'open')
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    % Element sectionner dans la boite de liste
    image2search = file_list{index_selected};
    % Si l'element selectionner est un sous-dossier, liste les fichiers du
    % sous-dossier
    if  handles.is_dir(handles.sorted_index(index_selected))
        cd (image2search)
        load_listbox(pwd,handles)
    else %Sinon affiche l'image
                I = imread(image2search);
                axes(handles.axes1);
                imshow(I);
                titre = strtrim(image2search);
                title(titre);
    end
end

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%Fonction executée lorsque le button Repetoire est cliquée
function SelectRepertory_Callback(hObject, eventdata, handles)
% hObject    handle to SelectRepertory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paf imagefiles
paf = uigetdir(matlabroot,'Selectionner le repertoire contenant les images');
cd (paf);
imagefiles = dir('*.jpg');
if  isempty(imagefiles)
  errordlg( 'Aucune image trouvée dans le dossier','File not found');
else
load_listbox(handles); %Charge la liste des fichiers
getComposantes(handles); % Calcule les composantes E V S de chaque composantes couleurs de chaque images et sauvegarde dans la base de donnée
end
%Fonction executée lorsqu'on appui sur le button Rechercher
%Appel la fonction getDistance qui retourne les distances entre le fichier
%selectionné et le reste des fichiers de la base de données

function FindButton_Callback(hObject, eventdata, handles)
% hObject    handle to FindButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global image2search nfiles EVS

%retourne un tableau de struc avec les noms de fichier et les distances.
%Trier en ordre croissant selon la distance
handles.sortedDistances = getDistances(image2search,EVS,nfiles);

%AFFICHAGE DU RESULTAT

%le nombre d'images à afficher. 
%Affiche les 10 premiers si le nombre de fichier est superieur à 10 ou
%affiche tous les images ordonnés pour ordre de ressemblance si le nombre de fichier est inférieur à 10

if nfiles < 11
    nfileToShow = nfiles;
else   
    nfileToShow = 11 ;
end

% Affiche les images avec le numero le nom de l'image dans les axes
%Il faut noter que l'image qui se trouve à la position 1 du resultat n'est
%pas affichée par qu'elle correspond à l'image recherché elle meme. La
%distance est 0. On affiche donc de 2 à 11 ou de 2 au nombre de fichiers si
%le nombre est inferieur à 11

s1 = 'axes';
for i = 2:nfileToShow
    s2 = num2str(i);
    s = strcat(s1,s2);
    axes(handles.(s));
    I = imread (handles.sortedDistances(i).name);
    imshow(I);
    s2 = num2str(i-1);
    s3 = handles.sortedDistances(i).name;
    titl = strcat(s2, {' : '}, s3);
    title(titl);
end

% Cette fonction affiche dans la list_box, la liste ordonnée selon le nom
% des fichiers images qui se trouvent dans le repertoire selectioné
function load_listbox(handles)
global imagefiles
[sorted_names,sorted_index] = sortrows({imagefiles.name}');
handles.file_names = sorted_names;
handles.is_dir = [imagefiles.isdir];
handles.sorted_index = sorted_index;
guidata(handles.figure1,handles)
set(handles.listbox1,'String',handles.file_names,'Value',1)

%Cette fonction extrait les couleurs (R G B) de chaque image, puis calcule
%les composantes E (Esperance), V (Variance), et S (moment d'ordre 3) de
%chacune des couleurs et sauvegardes le tout dans 
%la base de donnée(EVS) ( tableau de structure ayant le nom de fichier associer 
%à une Matrice 3x3 qui contient les valeurs des composantes E V S de chaque 
%couleur )

function getComposantes(handles)

global imagefiles nfiles EVS

%le nombre de fichier images
nfiles = length(imagefiles);

%Lecture des images et Extraction des composantes R G B de chaque image
%dans des tableaux de struct. Chaque structure a un champ nom qui contient
%le nom de l'image et un champ data qui contient les données de l'image
for k = 1:nfiles
    
    currentfilename=imagefiles(k).name;
    C = double(imread(currentfilename));
    
    iobject(k).name = currentfilename;
    iobjectR(k).name = currentfilename;
    iobjectG(k).name = currentfilename;
    iobjectB(k).name = currentfilename;
    
    iobject(k).data = C;
    iobjectR(k).data = C(:,:,1);
    iobjectG(k).data = C(:,:,2);
    iobjectB(k).data = C(:,:,3);
end
 
%tableau de struct (Base de données) qui contiendra les composants E V S de chaque couleur
%d'une image
for k = 1:nfiles
    EVS(k).name = iobject(k).name;
    EVS(k).data = zeros(3:3);
end


%Calcul les composants E V S et les sauvegardes dans la structure
%créée ci-dessus

% Pour chaque image, calcul E (Esperance), V (Variance), et S (moment d'ordre 3) 
% de chaque composante  R G B et sauvegarde dans la base de donnée EVS
%( tableau de struct ayant le nom de fichier associer à une Matrice 3x3 )
for k = 1:nfiles

    EVS(k).data(1,1)= mean(iobjectR(k).data(:));
    EVS(k).data(1,2)= mean(iobjectG(k).data(:));
    EVS(k).data(1,3)= mean(iobjectB(k).data(:));
    
    EVS(k).data(2,1)= var(iobjectR(k).data(:));
    EVS(k).data(2,2)= var(iobjectG(k).data(:));
    EVS(k).data(2,3)= var(iobjectB(k).data(:));
    
    EVS(k).data(3,1)= moment(iobjectR(k).data(:),3);
    EVS(k).data(3,2)= moment(iobjectG(k).data(:),3);
    EVS(k).data(3,3)= moment(iobjectB(k).data(:),3);
end  


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
