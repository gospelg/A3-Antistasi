private _unlocks = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
_cost = 2500;
_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < _cost) exitWith {hint format ["You do not have enough money! %1 € required",_cost]};
[0,(-1* _cost)] spawn A3A_fnc_resourcesFIA;
_crate = "I_supplyCrate_F" createVehicle position player;
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
_crate call jn_fnc_logistics_addAction;
_typeMax = 3

//Backpacks Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (lootBackpack - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
	}
	else {
		_amount = floor random 20;
		_crate addBackpackCargoGlobal [_loot,_amount];
	};
};
//Helmets Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (lootHelmet - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
	}
	else {
		_amount = floor random 12;
		_crate addItemCargoGlobal [_loot,_amount];
	};
};
//Vests Loot
for "_i" from 0 to floor random _typeMax do {
	_available = (lootVest - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
	}
	else {
		_amount = floor random 12;
		_crate addItemCargoGlobal [_loot,_amount];
	};
};
