

%-------------------------------------------------------------------------------

%                   EJERCICIO 1: GEOMETRIA PROYECTIVA
%          RECTIFICACIÓN DE IMAGEN CON CORRECCIÓN DE DISTORSIÓN PROYECTIVA

%-------------------------------------------------------------------------------
%MIEMBROS DEL EQUIPO:
%      - Lucía Teresa Rodríguez Fernández
%      - Sergio Requena Martínez
%      - Carlos Martín García

%-------------------------------------------------------------------------------

% Creacion de los datos de la imagen que se usaran para la rectificacion
clear
graphics_toolkit('gnuplot')

% leemos nuestra imagen ya formateada en escala de grises y con tamaño reducido a 501x340
foto=imread("andenMetro_gray.jpg");

% creamos las coordenadas x e y conforme a nuestra imagen
[y,x]=meshgrid(linspace(1,340,340),linspace(1,501,501));
x=x'; y=y';

foto=foto(340:-1:1,:);

figure, p=pcolor(x,y,foto); set(p,'EdgeColor','none'), colormap(gray),

save Rectificacion_datos
