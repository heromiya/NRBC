%COUNTNEIGHBOURS   Counts the number of neighbours each pixel has
%
% SYNOPSIS:
%  image_out = countneighbours(image_in,connectivity,edgeCondition)
%
% PARAMETERS:
%  connectivity: defines the metric, that is, the shape of the structuring
%     element. Possibilities are 1, for city-block metric, and ndims(image_in)
%     for square structuring element.
%  edgeCondition: defines the value of the pixels outside the image. It
%     can be 0 or 1.
%
% DEFAULTS:
%  connectivity = 2
%  edgeCondition = 0
%
% NOTE:
%  edgeCondition==1 is not implemented yet.

% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2000.
% September 2001: Added connectivity & edge condition. Cannot implement
%                 edge condition yet. Needs a change in DIPlib or some
%                 brute-force stuff.
% 21 August 2007: Connectivity bug fixed.
% 26 March 2009:  connectivity==inf => connectivity=ndims(image_in).
% 7 February 2012: Avoiding a change of default boundary condition in case of error.

function image_out = countneighbours(varargin)

d = struct('menu','Binary Filters',...
           'display','Count neighbours',...
           'inparams',struct('name',       {'image_in',   'connectivity','edgeCondition'},...
                             'description',{'Input image','Connectivity','Edge condition'},...
                             'type',       {'image',      'array',       'option'},...
                             'dim_check',  {0,            0,             0},...
                             'range_check',{'bin',        'N+',          {0,1}},...
                             'required',   {1,            0,             0},...
                             'default',    {'a',          inf,           0}...
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
   [image_in,connectivity,edgeCondition] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if isinf(connectivity) | connectivity==ndims(image_in)
   filtershape = 'rectangular';
   filtersize = 3^ndims(image_in);
elseif connectivity==1
   filtershape = 'diamond';
   filtersize = 2*ndims(image_in) + 1;
else
   error('Illegal connectivity for image dimensionality.')
end
edge = dip_getboundary(1);
if edgeCondition==1
   warning('edgeCondition==1 is not yet implemented. Setting edgeCondition to 0.')
end
dip_setboundary('add_zeros');
err = '';
try
   image_out = newim(image_in,'uint8');
   if any(image_in)
      image_out(image_in) = filtersize;
      image_out = dip_uniform(image_out,[],repmat(3,1,ndims(image_in)),filtershape);
      image_out(image_in) = image_out(image_in)-1;
   end
catch
   err = lasterr;
end
dip_setboundary(edge);
error(err);
