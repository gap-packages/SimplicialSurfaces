Read("14");
test := function()
    return List( [1..Size(vierzehn)], s->List( List( 
AllWildSimplicialSurfaces(vierzehn[s]) , Generators) , r-> Size( Positions( List( 
AllWildSimplicialSurfaces(r) , EulerCharacteristic ) , 2 ) ) ) );
    
end;
