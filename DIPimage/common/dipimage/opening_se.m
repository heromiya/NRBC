%OPENING_SE   Grey-value opening with a user-defined structuring element
%
% SYNOPSIS:
%  image_out = opening_se(image_in,se)
%
% PARAMETERS:
%  se: binary or grey-value image with the shape for the structuring element

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2001.
% Input auto convert to bin (BR) March 2002
% 7 June 2002: Added support for grey-value morphology in DIPlib.

function image_out = opening_se(varargin)

d = struct('menu','Morphology',...
  'display','Custom opening',...
  'inparams',struct('name',       {'image_in',   'se'},...
    'description',{'Input image','Structuring element'},...
    'type',       {'image',      'image'},...
    'dim_check',  {0,            0},...
    'range_check',{'noncomplex', 'noncomplex'},...
    'required',   {1,            1},...
    'default',    {'a',          'b'}...
  ),...
  'outparams',struct('name',{'image_out'},...
    'description',{'Output image'},...
    'type',{'image'}...
  )...
);
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,se] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_opening(image_in,se,ones(ndims(image_in),1),'user_defined');
