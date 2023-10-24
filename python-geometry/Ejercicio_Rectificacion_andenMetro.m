
%-------------------------------------------------------------------------------

%                   EJERCICIO 1: GEOMETRIA PROYECTIVA
%          RECTIFICACIÓN DE IMAGEN CON CORRECCIÓN DE DISTORSIÓN PROYECTIVA
%          Módulo 2: Ejercicio_Rectificacion_andenMetro.m
%-------------------------------------------------------------------------------
%MIEMBROS DEL EQUIPO
%      - Lucía Teresa Rodríguez Fernández
%      - Sergio Requena Martínez
%      - Carlos Martín García

%-------------------------------------------------------------------------------

%  PASO 1: CORRECCIÓN DISTORSION POR LINEAS PARALELAS Y PERPENDICULARES
%------------------------------------------------------------------------------
% Realizacion de la rectificacion de la distorsion proyectiva.
% Cargamos el fichero resultante de procesamiento de la imagen en el módulo 1
load Rectificacion_datos
graphics_toolkit('gnuplot')

%Procedemos a indicar los puntos tanto verticales como horizontales que usaremos
%para el calculo de las rectas necesarias para los 2 puntos de fuga

%Puntos verticales               %Puntos horizontales
P_v1=[384,98,1];                  P_h1=[295,119,1];
P_v2=[403,148,1];                 P_h2=[322,163,1];

% Las dos rectas verticales       % Las dos rectas horizontales
l_vert_1=cross(P_v1,P_v2);        l_hori_1=cross(P_h2,P_v2);
l_vert_2=cross(P_h1,P_h2);        l_hori_2=cross(P_h1,P_v1);


% Los puntos de fuga de las rectas verticales y horizontales
P_fuga_vert=cross(l_vert_1,l_vert_2);
P_fuga_hori=cross(l_hori_1,l_hori_2);

% Calculo de la recta de fuga
l_fuga=cross(P_fuga_vert,P_fuga_hori);

%Calculo de la Matriz de la imagen sin distorsión
HpT=[1,0,-l_fuga(1)/l_fuga(3); 0, 1, -l_fuga(2)/l_fuga(3); 0, 0, 1/l_fuga(3)];
H=inv( HpT)';


clear x_trans y_trans
for i=1:size(x,1)
  for j=1:size(x,2)
    vector_trans=H*[x(i,j);y(i,j);1];
    x_trans(i,j)=vector_trans(1)/vector_trans(3);
    y_trans(i,j)=vector_trans(2)/vector_trans(3);
  end
end

%figure, p=pcolor(x_trans,y_trans,foto); set(p,'EdgeColor','none'), colormap(gray),


%  PASO 2: HOMOGRAFÍA
%------------------------------------------------------------------------------
% A través de este método suponiendo los puntos en los que quedaría 1 de las baldosas
% de nuestra imagen, vamos a recuperar sus ángulos rectos

% Puntos del cuadrado rectificado supuestos por nosotros(pp)
ah1=[501, 273];
ah2=[551, 273];
ah3=[551, 223];
ah4=[501, 223];


%Nuevos puntos tras transformación del método 2 (rectas paralelas y perpendiculares)
%(p)
a1h=H*P_v1';           a2h=H*P_h1';
a4h=H*P_v2';           a3h=H*P_h2';

% Para pasar estos puntos a coordenadas homogeneas dividimos entre su último elemento (3)
% para tener como ultima coordenada el valor 1

a1h=a1h/a1h(3);            a2h=a2h/a2h(3);
a3h=a3h/a3h(3);            a4h=a4h/a4h(3);

a = [a1h a2h a3h a4h];

%Una vez tenemos 'h' el siguiente paso será definir la función que realizará
%el cálculo de la matriz de Homografía 'H'
function salida = calculo_homografia(p,pp)

salida = [p(1) p(2) 1 0 0 0 -p(1)*pp(1) -p(2)*pp(1); 0 0 0 p(1) p(2) 1 -p(1)*pp(2) -p(2)*pp(2)];

end

A = [calculo_homografia(a1h,ah1);calculo_homografia(a2h,ah2);calculo_homografia(a3h,ah3);calculo_homografia(a4h,ah4)];

b=[ah1';ah2';ah3';ah4'];
h=inv(A)*b;

   H_homografia =[h(1:3)'; h(4:6)'; h(7:8)' 1];


for i=1:size(x,1)
  for j=1:size(x,2)
    vector_trans_homogenea=H_homografia*[x_trans(i,j);y_trans(i,j);1];
    x_trans_homogenea(i,j)=vector_trans_homogenea(1)/vector_trans_homogenea(3);
    y_trans_homogenea(i,j)=vector_trans_homogenea(2)/vector_trans_homogenea(3);
  end
end




% Puede pasar que las magnitudes de las nuevas coordenadas x_trans e y_trans
% sean muy grandes o muy pequeñas. Voy a hacer un reescalado para que
% tengan numeros razonables. Por ejemplo, elijo que el máximo de las coordenadas
% sea 1000
s_x=1000/max(max(x_trans));
s_y=1000/max(max(y_trans));
x_trans=x_trans*s_x;
y_trans=y_trans*s_y;

ax_trans=a(1,:)*s_x;
ay_trans=a(2,:)*s_y;

save Rectificacion_hecha

figure, p=pcolor(x_trans,y_trans,foto); set(p,'EdgeColor','none'), colormap(gray), hold on, plot(ax_trans,ay_trans,'*'), hold off;

figure, p=pcolor(x_trans_homogenea,y_trans_homogenea,foto); set(p,'EdgeColor','none'), colormap(gray),



