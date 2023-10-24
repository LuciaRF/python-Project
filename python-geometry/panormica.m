#Lucía Teresa Rodríguez Fernández
#Sergio Requena Martínez
#Carlos Martín García

load PanoramicaA_datos

graphics_toolkit('gnuplot')

%A continuación se seleccionan los puntos de las 4 imágenes relacionadas. Se toman 4 puntos de la imagen 1 y a continuación
%se localizan esos puntos en la siguiente imagen. Por lo tanto, aunque los puntos sean diferentes la localización en la imagen será la misma.
%Este proceso se realiza de igual forma para las 4 imágenes de forma que la imagen 1 y la 2 estarán relacionadas, de igual forma la 2 con la 3 y por
%último la 3 y la 4.

%1_2 foto 1 & foto 2 cuadrado 1

P1_1 = [277.464, 400-185.194]';
P1_2 = [315.803, 400-186.215]';
P1_3 = [318.734, 400-360.114]';
P1_4 = [275.809, 400-354.041]';


P2_1 = [115.405, 400-177.659]';
P2_2 = [155.4, 400-177.659]';
P2_3 = [158.709, 400-352.868]';
P2_4 = [115.405, 400-348.590]';

%2_3 foto 2 & foto 3 cuadrado 2

P3_1 = [264.557, 400-161.856]';
P3_2 = [327.480, 400-161.235]';
P3_3 = [326.629, 400-332.166]';
P3_4 = [267.063, 400-326.093]';


P4_1 = [35.3688, 400-149.711]';
P4_2 = [102.452, 400-149.711]';
P4_3 = [105.808, 400-323.678]';
P4_4 = [39.529, 400-320.021]';

%3_4 foto 3 & foto 4 cuadrado 2

P5_1 = [334.146, 400-142.396]';
P5_2 = [369.980, 400-142.396]';
P5_3 = [372.061, 400-312.085]';
P5_4 = [335.423, 400-311.464]';


P6_1 = [24.1174, 400-188.631]';
P6_2 = [63.3083, 400-188.010]';
P6_3 = [65.8139, 400-366.255]';
P6_4 = [27.0485, 400-368.050]';

puntosImagen1 = [P1_1, P1_2, P1_3, P1_4];
puntosImagen2 = [P2_1, P2_2, P2_3, P2_4];
puntosImagen3 = [P3_1, P3_2, P3_3, P3_4];
puntosImagen4 = [P4_1, P4_2, P4_3, P4_4];
puntosImagen5 = [P5_1, P5_2, P5_3, P5_4];
puntosImagen6 = [P6_1, P6_2, P6_3, P6_4];

%A continuación, se muestra una serie de funciones auxiliares que permiten automatizar el proceso del cálculo de la
%homografía ya que se deberá realizar por cada imagen para formar la panorámica.

%Esta funcion devuelve valor de la matriz de homografía H de las imágenes

function homografia = get_homografia(puntosIniciales, puntosFinales)
  A = [calculo_homografia(puntosIniciales(:,1),puntosFinales(:,1));
       calculo_homografia(puntosIniciales(:,2),puntosFinales(:,2));
       calculo_homografia(puntosIniciales(:,3),puntosFinales(:,3));
       calculo_homografia(puntosIniciales(:,4),puntosFinales(:,4))];

  b=[puntosFinales(:,1);puntosFinales(:,2);puntosFinales(:,3);puntosFinales(:,4)];
  h=inv(A)*b;

  homografia =[h(1:3)'; h(4:6)'; h(7:8)' 1];
end

%Esta funcion devuelve la matriz de relación entre los puntos de las imágenes
function salida = calculo_homografia(p,pp)

salida = [p(1) p(2) 1 0 0 0 -p(1)*pp(1) -p(2)*pp(1); 0 0 0 p(1) p(2) 1 -p(1)*pp(2) -p(2)*pp(2)];
end

%A continuación, se calcula las 2 primeras homografias que relacionan la imagen 1 con la 2 y la 2 con la 3. Siendo la imagen 2 la que se mantiene estable
%y no va a sufrir modificaciones para realizar la panorámica.

H1_2 = get_homografia(puntosImagen1,puntosImagen2);
H3_2 = get_homografia(puntosImagen4,puntosImagen3);

%Ahora llega el paso más importante para realizar la panorámica con más de 3 imágenes ya que para unir las 3 primeras imagenes con la cuarta.
%Como se ha comentado se han tomado los puntos para que estén relacionados entre imágenes por lo tanto el punto 5 hace referencia a los puntos tomados en la imagen 3
%que a su vez están localizados en la imagen 4. Y para que puedan ser relacionados correctamente estos puntos deben estar deformados para que a la hora de hacer la
%homografia los puntos inciales y que van ser relacionados con los puntos de la imagen 6 ya hayan sufrido la transformación de la matriz de homografía.

puntos_originales = [puntosImagen5;ones(1,4)];
puntos5_def = H3_2*puntos_originales;
puntos5_def = puntos5_def(1:2,:)./puntos5_def(3,:);

%El calculo de esta homografía relaciona los puntos ya distorsionados que forman parte de la primera parte de la panorámica y la imagen 4 que queda por unir. De esta forma,
%relaciona puntos deformados de la panorámica y los puntos de la imagen sin deformar. Por lo tanto, cuando se aplique esa matriz a los valores de la imagen se creará la imagen correctamente
H6_3d = get_homografia(puntosImagen6,puntos5_def(1:2,:));


%Se aplican las matrices de homografía a las imágenes relacionado

%La imagen 1 y la imagen 2 dejando a 2 fija
for i=1:size(x1,1)
  for j=1:size(x1,2)
    vector_trans=H1_2*[x1(i,j);y1(i,j);1];
    x12_trans(i,j)=vector_trans(1)/vector_trans(3);
    y12_trans(i,j)=vector_trans(2)/vector_trans(3);
  end
end

%La imagen 3 y la imagen 2 dejando a 2 fija

for i=1:size(x1,1)
  for j=1:size(x1,2)
    vector_trans=H3_2*[x1(i,j);y1(i,j);1];
    x32_trans(i,j)=vector_trans(1)/vector_trans(3);
    y32_trans(i,j)=vector_trans(2)/vector_trans(3);
  end
end

%La imagen 4 y la imagen distorsionada de la panorámica 3 fija

for i=1:size(x1,1)
  for j=1:size(x1,2)
    vector_trans=H6_3d*[x(j,i);y(j,i);1];
    x6_3d_trans(i,j)=vector_trans(1)/vector_trans(3);
    y6_3d_trans(i,j)=vector_trans(2)/vector_trans(3);
  end
end

%Se representan las 4 fotos formando la panorámica

figure, p=pcolor(x12_trans,y12_trans,foto1); set(p,'EdgeColor','none'), colormap(gray),hold on,
p=pcolor(x32_trans,y32_trans,foto3); set(p,'EdgeColor','none'), colormap(gray), hold on
p=pcolor(x2,y2,foto2); set(p,'EdgeColor','none'), colormap(gray),
p=pcolor(x6_3d_trans,y6_3d_trans,foto4); set(p,'EdgeColor','none'), colormap(gray); hold on

