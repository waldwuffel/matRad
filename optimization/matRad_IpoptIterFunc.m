function flag = matRad_IpoptIterFunc(iter,objective,~,~)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad IPOPT callback: iter function
% 
% call
%   Flag = matRad_IpoptIterFunc(iter,objective,parameter,maxiter,figureWait)
%
% input
%   iter:       current number of iteration
%   objective:  current value of objective
%   parameter:  struct with current parameter of optimization
%   maxiter:    max number of iterations
%   figureWait: handle to waitbar
%
% output
%   Flag: indicates if optimization stops (false) / proceeds (true)
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015 the matRad development team. 
% 
% This file is part of the matRad project. It is subject to the license 
% terms in the LICENSE file found in the top-level directory of this 
% distribution and at https://github.com/e0404/matRad/LICENSES.txt. No part 
% of the matRad project, including this file, may be copied, modified, 
% propagated, or distributed except according to the terms contained in the 
% LICENSE file.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global matRad_STRG_C_Pressed
global matRad_objective_function_value;

% update global objective function value
matRad_objective_function_value(iter+1) = objective;

% check if user pressed ctrl-c
if matRad_STRG_C_Pressed
    flag = false;
else
    flag = true;
end

% plot objective function output
figHandles = get(0,'Children');
if ~isempty(figHandles)
    IdxHandle = strcmp(get(figHandles,'Name'),'Progress of Optimization');
else
    IdxHandle = [];
end

if any(IdxHandle)
    figOpt = figHandles(IdxHandle);
    AxesInfigOpt = findall(figOpt,'type','axes');
    set(AxesInfigOpt,'NextPlot', 'replacechildren')
    children = get(AxesInfigOpt,'children');
    delete(children);
else
    figOpt = figure('Name','Progress of Optimization','NumberTitle','off');
    hold on, grid on, grid minor,
    AxesInfigOpt = findall(figOpt,'type','axes');
end

set(AxesInfigOpt,'YScale','log');
title(AxesInfigOpt,'Progress of Optimization','LineWidth',14),
xlabel(AxesInfigOpt,'# iterations','Fontsize',14),ylabel(AxesInfigOpt,'objective function value','Fontsize',14)

% draw updated axes
plot(AxesInfigOpt,0:1:iter,matRad_objective_function_value,'xb','LineWidth',1.5);
drawnow

end