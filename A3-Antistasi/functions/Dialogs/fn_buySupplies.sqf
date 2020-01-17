private _unlocks = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
_cost = 750;
_resourcesFIA = server getVariable "resourcesFIA";
if (_resourcesFIA < _cost) exitWith {hint format ["You do not have enough money! %1 € required",_cost]};
[0,(-1* _cost)] spawn A3A_fnc_resourcesFIA;
_crate = "I_supplyCrate_F" createVehicle position player;
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;
clearBackpackCargoGlobal _crate;
_crate call jn_fnc_logistics_addAction;

private _crateItemTypeMax = 5z;
private _crateAttachmentTypeMax = 8;
private _crateDeviceTypeMax = 2;

//Items Loot
[3, "Generating Items", "fn_buySupplies"] call A3A_fnc_log;
for "_i" from 0 to floor random _crateItemTypeMax do {
	_available = (lootItem - _unlocks - itemCargo _crate);
	[3, format ["Breakdown: %1, %2, %3", lootItem, _unlocks, itemCargo _crate],"fn_buySupplies"] call A3A_fnc_log;
	[3, format ["Items available: %1", _available],"fn_buySupplies"] call A3A_fnc_log;
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		[3, "No Items Left in Loot List","fn_buySupplies"] call A3A_fnc_log;
	}
	else {
		[3, format ["Item chosen: %1", _loot],"fn_buySupplies"] call A3A_fnc_log;
		_amount = floor random [2,5,7];
		_crate addItemCargoGlobal [_loot,_amount];
		[3, format ["Spawning %2 of %3", _amount,_loot],"fn_buySupplies"] call A3A_fnc_log;
	};
};

for "_i" from 0 to floor random _crateAttachmentTypeMax do {
	_available = (lootAttachment - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | Supply Crate | No Attachment Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [3,5,7];
		_crate addItemCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | Supply Crate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};

//Device Loot
for "_i" from 0 to floor random _crateDeviceTypeMax do {
	_available = (lootDevice - _unlocks - itemCargo _crate);
	_loot = selectRandom _available;
	if (isNil "_loot") then {
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | Supply Crate | No Device Bags Left in Loot List",servertime]};
	}
	else {
		_amount = floor random [1,3,5];
		_crate addBackpackCargoGlobal [_loot,_amount];
		if (debug) then {diag_log format ["%1: [Antistasi] | INFO | Supply Crate | Spawning %2 of %3",servertime,_amount,_loot]};
	};
};
