private _unlocks = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
_cost = 3500;
_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < _cost) exitWith {hint format ["You do not have enough money! %1 € required",_cost]};
[0,(-1* _cost)] spawn A3A_fnc_resourcesFIA;
_crate = "I_supplyCrate_F" createVehicle position player;
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
_crate call jn_fnc_logistics_addAction;
_typeMax = 2;

//rocket launchers Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (allRocketLaunchers - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Rocket launchers Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [1,3,5];
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};

//missile launchers Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (allMissileLaunchers - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No missile launchers Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [1,2,5];
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};

//snipers Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (allSniperRifles - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No snipers Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [1,3,5];
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};

//Ammo Loot
for "_i" from 0 to floor random 4 do {
    _projectiles = (allMagMissile + allMagRocket)
    _available = (_projectiles - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | No Ammo Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [2,5,8];
		_crate addMagazineCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | NATOCrate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
