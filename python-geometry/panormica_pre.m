
#Lucía Teresa Rodríguez Fernández
#Sergio Requena Martínez
#Carlos Martín García

clear
close all
graphics_toolkit('gnuplot')

%Para llevar acabo el proyecto se han realizado 4 fotografías para realizar la panorámica y posteriormente tomar los datos a través de meshgrid para poder representarlos 

% leer las imagenes
foto1=imread("ventana1.jpg");
foto2=imread("ventana2.jpg");
foto3=imread("ventana3.jpg");
foto4=imread("ventana4.jpg");


% crear las coordenadas x e y conforme a las fotos
[y,x]=meshgrid(linspace(400,1,400),linspace(1,400,400));

x1=x'; y1=y';
x2=x1; y2=y1;


figure, p=pcolor(x1,y1,foto1); set(p,'EdgeColor','none'), colormap(gray),
figure, p=pcolor(x1,y1,foto2); set(p,'EdgeColor','none'), colormap(gray),

figure, p=pcolor(x1,y1,foto3); set(p,'EdgeColor','none'), colormap(gray),
figure, p=pcolor(x1,y1,foto4); set(p,'EdgeColor','none'), colormap(gray),

save PanoramicaA_datos
