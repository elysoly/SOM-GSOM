function ns=neighborhood_size(sigma0,mode,param)
switch mode
    case 'exp'
         ns=round(sigma0*exp(-epoch/threshold));%neighborhood_size
    case 'gaussy'
         ns=exp(-param*sigma0);
        
    case 'radius'
        ns=1;
    case 'const'
        ns=1;
end