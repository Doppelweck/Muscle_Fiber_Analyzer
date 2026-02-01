function [T1, T12h, T2, T2x, T2a, T2ax, T0] = controller_helper_get_all_fibers(StatsMat)

    Index = strcmp({StatsMat.FiberType}, 'Type 1');
    T1 = StatsMat(Index);
    
    %find all Type 12h Fibers
    Index = strcmp({StatsMat.FiberType}, 'Type 12h');
    T12h = StatsMat(Index);
    
    Index = ismember({StatsMat.FiberType}, {'Type 2','Type 2x','Type 2a','Type 2ax'});
    T2 = StatsMat(Index);
    
    %find all Type 2x Fibers
    Index = strcmp({StatsMat.FiberType}, 'Type 2x');
    T2x = StatsMat(Index);
    
    %find all Type 2a Fibers
    Index = strcmp({StatsMat.FiberType}, 'Type 2a');
    T2a = StatsMat(Index);
    
    %find all Type 2ax Fibers
    Index = strcmp({StatsMat.FiberType}, 'Type 2ax');
    T2ax = StatsMat(Index);
    
    %find all Type 0 Fibers
    Index = strcmp({StatsMat.FiberType}, 'undefined');
    T0 = StatsMat(Index);
end