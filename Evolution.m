function phi = Evolution(phi, u0, nu, mu, timeStep, lambda, epsilon)
% function used to update the level set function phi, exploiting energy
% defined in "Active Contour without Edges", IEEE TIP 2001, Chan and Vese.
phi = NeumannBoundCond(phi);    
K = curvature_central(phi);     % compute div(D\phi/(|D\phi|));
u0 = u0./max(u0(:));            % normalize the give image;

% compute dirac function
D = (epsilon/pi)./(epsilon^2.+phi.^2);

in = find(phi <= 0);
out = find(phi > 0);
% compute average intensity from inside and outside
c1 = sum(u0(in))/(length(in)+eps);
c2 = sum(u0(out))/(length(out)+eps);
% compute fitting term defined in CV model;
F = lambda*(u0-c1).^2 - lambda*(u0-c2).^2;  % term F1 + F2;

% compute dphi/dt.
F = lambda*F./max(max(abs(F)));
F = F.*60; % enhance effection of data force.

% update level set function. 
length_term = nu.*D.*K*25;          % length term;
fitting_term = D.*F;                % fitting term;
penal_term = mu*(4*del2(phi)-K);    % penalizing term, proposed in Chunming Li's paper: 
    % "Level Set Evolution Without Re-initialization: A New Variational Formulation"
    % IEEE CVPR, 2005.

% update \phi
phi = phi + timeStep*(length_term + fitting_term + penal_term);


% other function definitions:
function g = NeumannBoundCond(f)
% Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);  
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);          
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);  

function k = curvature_central(u)                       
% compute curvature
[ux,uy] = gradient(u);                                  
normDu = sqrt(ux.^2+uy.^2+1e-10);                       % the norm of the gradient plus a small possitive number 
                                                        % to avoid division by zero in the following computation.
Nx = ux./normDu;                                       
Ny = uy./normDu;
[nxx,junk] = gradient(Nx);                              
[junk,nyy] = gradient(Ny);                              
k = nxx+nyy;                                            % compute divergence