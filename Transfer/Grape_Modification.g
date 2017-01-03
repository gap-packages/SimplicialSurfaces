DeclareOperation("ConnectedComponents",[IsRecord]);
InstallMethod(ConnectedComponents,"for GRAPE graph",[IsRecord],0, 
function(gamma)
#
# Returns the set of the vertex-sets of the connected components
# of  gamma,  which must be a simple graph.
#
local comp,used,i,j,x,cmp,laynum;
if not IsGraph(gamma) or not IsSimpleGraph(gamme) then 
   TryNextMethod();
fi;
comp:=[]; 
used:=BlistList([1..gamma.order],[]);
for i in [1..gamma.order] do 
   # Loop invariant: used[j]=true for all j<i. 
   if not used[i] then   # new component
      laynum:=LocalInfo(gamma,i).layerNumbers;
      cmp:=Filtered([i..gamma.order],j->laynum[j]>0);
      IsSSortedList(cmp);
      for x in Orbit(gamma.group,cmp,OnSets) do
	 Add(comp,x);
	 for j in x do 
	    used[j]:=true;
	 od;
      od;
   fi; 
od;
return SSortedList(comp);
end);
