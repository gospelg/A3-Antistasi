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

private _crateWepTypeMax = 4;
private _crateAmmoTypeMax = 8;

private _weaponLootInfo = [
	[allMachineGuns, unlockedMachineGuns, 1],
	[allSniperRifles, unlockedSniperRifles, 1],
	[allRocketLaunchers, unlockedRocketLaunchers, 3],
	[allMissileLaunchers, unlockedMissileLaunchers, 4] //Increase weighting for RHS.
];

private _quantityScalingFactor = if (!cratePlayerScaling) then {1} else {
	private _playerCount = if(!isNil "spoofedPlayerCount") then {spoofedPlayerCount} else {count (call A3A_fnc_playableUnits)};
	//Scale it down to a 50% loot rate at 20 players.
	1 / (1 + _playerCount / 20);
};

//Build the weighting array, as used by selectRandomWeighted
private _weaponLootWeighting = [];
{
	_x params ["_allX", "_unlockedX", "_weighting"];
	//If the array contains weapons, and we haven't unlocked everything, add it to the pool to be selected.
	if (count _allX > 0 && {(count _unlockedX / count _allX) < 1}) then {
		_weaponLootWeighting pushBack [_allX, _unlockedX];
		_weaponLootWeighting pushBack _weighting;
	};
} forEach _weaponLootInfo;

private _fnc_pickRandomFromAProbablyNotInB = {
	params ["_arrayA", "_arrayB"];

	//Only run if there's more than 100 items in the array.
	if (count _arrayA min count _arrayB < 100) exitWith {
		selectRandom (_arrayA - _arrayB);
	};

	//Calculate what % of arrayB is likely in arrayA. 
	//Let's never go over 100% loaded. It's theoretically possible if arrayB ever is somehow larger than arrayA/
	//There's not a lot of value in running more than 10 iterations on a 90%+ loading anyway.
	private _percentageLoaded = (count _arrayB / count _arrayA) min 1;
	//Rough heuristic for how many iterations we need to run to get a good chance of success.
	private _iterations = floor (10 * _percentageLoaded);

	private _choice = selectRandom _arrayA;
	[3, format ["Function check for: %1", _choice],"fn_NATOCrate"] call A3A_fnc_log;
	private _foundValid = true;
	if (_choice in _arrayB) then {
		_foundValid = false;
		[3, format ["Item already unlocked, rolling again."],"fn_NATOCrate"] call A3A_fnc_log;
		for "_i" from 0 to _iterations do {
			_choice = selectRandom _arrayA;
			//We did it!
			if !(_choice in _arrayB) exitWith {
				_foundValid = true;
			};
		}
	};

	if (_foundValid) then {
		_choice;
	} else {
		//We failed, just... return something.
		selectRandom _arrayA;
	};
};

//Pick a weapon for the crate. Pick carefully, unless in CHAOS MODE, in which case, we just pick totally at random.
private _fnc_pickWeapon = if (bobChaosCrates) then 
{
	{
		private _category = (selectRandom _weaponLootInfo) select 0;
		selectRandom _category;
	}
} 
else 
{
	{
		private _category = selectRandomWeighted _weaponLootWeighting;
		if (isNil "_category") exitWith {};

		[3, format ["Selected Weapon Category: %1", _category],"fn_NATOCrate"] call A3A_fnc_log;
		//Category is in format [allX, unlockedX];
		[_category select 0, _category select 1] call _fnc_pickRandomFromAProbablyNotInB;
	}
};

//Pick the amount of X to spawn. Use gaussian distribution, unless we're in CHAOS MODE.
private _fnc_pickAmount = if (bobChaosCrates) then 
{
	{
		params ["_max"];
		floor random _max;
	}
} 
else 
{
	{
		params ["_max"];
		floor (random [1, floor (_max/2), _max] * _quantityScalingFactor);
	}
};

private _fnc_pickNumberOfTypes = if (bobChaosCrates) then
{
	{
		params ["_max"];
		floor random _max;
	}
} 
else 
{
	{
		params ["_max"];
		floor random [1, floor (_max/2), _max];
	}
};

//Weapons Loot
[3, "Generating Weapons", "fn_NATOCrate"] call A3A_fnc_log;
for "_i" from 0 to (_crateWepTypeMax call _fnc_pickNumberOfTypes) do {
	private _loot = call _fnc_pickWeapon;

	if (isNil "_loot") then {
		[3, "No Weapons Left in Loot List Or Pick Random Failed","fn_NATOCrate"] call A3A_fnc_log;
	}
	else 
	{
		[3, format ["Adding weapon: %1", _loot],"fn_NATOCrate"] call A3A_fnc_log;
		_amount = crateWepNumMax call _fnc_pickAmount;
		_crate addWeaponWithAttachmentsCargoGlobal [[ _loot, "", "", "", [], [], ""], _amount];
		for "_i" from 0 to _amount do {
			_magazine = selectRandom getArray (configFile / "CfgWeapons" / _loot / "magazines");
			//Abort if the gun has no magazines.
			if (isNil "_magazine") exitWith {};
			_magAmount = if ((getText (configFile >> "CfgMagazines" >> _magazine >> "ammo") isKindOf "MissileBase")) then {
				floor random 3;
			} else {
				floor random [1,6,1]
			};
			[3, format ["Spawning %1 magazines of %2 for %3", _magAmount, _magazine, _loot],"fn_NATOCrate"] call A3A_fnc_log;
			_crate addMagazineCargoGlobal [_magazine, _magAmount];
			[3, format ["Spawning %1 of %2", _amount, _loot],"fn_NATOCrate"] call A3A_fnc_log;
		};
	};
};
