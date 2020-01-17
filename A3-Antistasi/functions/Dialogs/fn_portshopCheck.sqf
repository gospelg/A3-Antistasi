_seaports = ({sidesX getVariable [_x,sideUnknown] == teamPlayer} count seaports);
if (_seaports < 1) then {
    hint "You must control at least one seaport before importing material.";
	}
else {
    nul = createDialog "portshop_option";
};
