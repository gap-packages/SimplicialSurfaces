##############################################################################
##
#W  folding_plan.gi          SimplicialSurfaces           Markus Baumeister
##
##
#Y  Copyright (C) 2016-2017, Markus Baumeister, Lehrstuhl B für Mathematik,
#Y  RWTH Aachen
##
##  This file is free software, see license information at the end.
##
##  This file contains the implementation part for the folding plans of the 
##	SimplicialSurfaces package. A folding plan consists of an identification
##	and two oriented faces belongig to the identified faces.
##
##

##
##	We use a representation that doesn't do much.
##
DeclareRepresentation("IsFoldingPlanRep", IsFoldingPlan, []);

##	accompanying type
FoldingPlanType := NewType( FoldingPlanFamily, IsFoldingPlanRep );


#############################################################################
#############################################################################
##
##						Start of constructors
##
##


##
##
##							End of constructors
##
#############################################################################
#############################################################################





#
###  This program is free software: you can redistribute it and/or modify
###  it under the terms of the GNU General Public License as published by
###  the Free Software Foundation, either version 3 of the License, or
###  (at your option) any later version.
###
###  This program is distributed in the hope that it will be useful,
###  but WITHOUT ANY WARRANTY; without even the implied warranty of
###  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
###  GNU General Public License for more details.
###
###  You should have received a copy of the GNU General Public License
###  along with this program.  If not, see <http://www.gnu.org/licenses/>.
###
