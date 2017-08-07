function ns=neighborhood_strength(d,mode,param)
switch mode
    case 'gaussy'
         ns=exp(-d^2/(2*param^2));
    case 'exp'
         ns=exp(-param*d);
        
    case 'radius'
        ns=1;
    case 'const'
        ns=1;
end