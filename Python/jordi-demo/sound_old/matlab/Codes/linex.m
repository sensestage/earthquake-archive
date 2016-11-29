function [h] = linex(x,color,yrange)
%function linex(x,color,yrange) Draw a vertical line at x
%
% add feature:
% color
% yrange

if nargin <=2, yrange=get(gca,'ylim'); end
if nargin <=1, color = 'b'; end
if nargin <1, x = 0; end

h = line([x,x],yrange);
set(h,'Color',color);

