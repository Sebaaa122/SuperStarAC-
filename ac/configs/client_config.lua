--[[ 
	===================================== | SUPERSTARS ANTICHEAT | =====================================
	ENGLISH:
    Welcome to the SuperStar AntiCheat config! Below you can activate / deactivate each part of the anticheat.
	Dacă apreciezi munca noastră, te așteptăm cu un review pe discord <3.
	https://discord.gg/vR9qAeREz5

	ROMANIA:
    Bine ai venit in config-ul AntiCheat-ului SuperStar! Mai jos poti sa activezi/dezactivezi fiecare chestie in parte a anticheat-ului.
	Daca apreciezi munca noastra, te asteptam cu un review pe discord <3.
	https://discord.gg/vR9qAeREz5
	===================================== | SUPERSTARS ANTICHEAT | =====================================
--]]

SuperStars_AC = {}
SuperStars_AC.Enable = true
SuperStars_AC.MainAnticheat = true

SuperStars_AC.UseESX = false  -- RO: Foloseste aceasta optiune doar daca folosesti Framework-ul ESX | EN: Use this option only if you are using the ESX Framework
SuperStars_AC.ESXTrigger = "esx:getSharedObject" -- RO: Dacă utilizați ESX, puneți trigger-ul chiar aici | EN: If you use ESX, put the trigger right here

SuperStars_AC.GodModeProtection = true
SuperStars_AC.AntiSpectate = true
SuperStars_AC.AntiSpeedHacks = true
SuperStars_AC.AntiBoomDamage = true
SuperStars_AC.PlayerProtection = false
SuperStars_AC.AntiBlacklistedWeapons = true
SuperStars_AC.AntiVDM = true

SuperStars_AC.AntiDamageModifier = true
SuperStars_AC.AntiThermalVision = true
SuperStars_AC.AntiNightVision = true
SuperStars_AC.AntiResourceStartorStop = true
SuperStars_AC.AntiCommandInjection = false -- RO: Folositi aceasta optiune daca credeti ca cineva poate injecta comenzi. Este recomandat sa nu folositi aceasta optiune. | EN: Use this option if you think someone can inject commands. It is recommended that you do not use this option.
SuperStars_AC.AntiLicenseClears = true

SuperStars_AC.AntiCInjection = false -- RO: Folositi aceasta optiune daca credeti ca cineva poate injecta comenzi. Este recomandat sa nu folositi aceasta optiune. | EN: Use this option if you think someone can inject commands. It is recommended that you do not use this option.
SuperStars_AC.BlackListedCMD = {  -- RO: Puneti aici toate comenzile care credeti ca ar fi vulnerabile. | EN: Put all the commands you think are vulnerable here.
	"killmenu",
	"chocolate",
	"pk",
	"haha",
	"lol",
	"panickey",
	"killmenu",
	"panik",
	"lynx",
	"brutan",
	"panic",
	"purgemenu"
}

SuperStars_AC.DisableVehicleWeapons = true
SuperStars_AC.AntiKeyboardNativeInjections = true
SuperStars_AC.AntiCheatEngine = true
SuperStars_AC.AntiNoclip = true
SuperStars_AC.AntiRadar = false
SuperStars_AC.AntiRagdoll = true
SuperStars_AC.AntiInvisible = true -- RO: Daca folositi aceasta optiune, membrii staff-ului risca ban de la anticheat daca foloseste noclip-ul. | EN: If you use this option, staff members risk a ban on anticheat if they use the noclip
SuperStars_AC.AntiExplosiveBullets = true
SuperStars_AC.AntiBlips = true
SuperStars_AC.AntiInfiniteAmmo = true
SuperStars_AC.AntiPedChange = false
SuperStars_AC.AntiVehicleModifiers = true
SuperStars_AC.AntiSuperJump = true
SuperStars_AC.AntiFreeCam = false
SuperStars_AC.AntiFlyandVehicleBelowLimits = true
SuperStars_AC.DeleteBrokenCars = true
SuperStars_AC.ClearPedsAfterDetection = true
SuperStars_AC.ClearObjectsAfterDetection = true
SuperStars_AC.ClearVehiclesAfterDetection = true
SuperStars_AC.AntiMenyoo = true
SuperStars_AC.AntiPedRevive = true --RO: Acest lucru nu funcționează perfect, dacă jucătorii normali sunt banati din această cauză, dezactivați-l. | EN: This isn't perfectly working, if normal players get banned because of this, disable it.
SuperStars_AC.AntiSuicide = true --RO: Acest lucru nu funcționează perfect, dacă jucătorii normali sunt banati din această cauză, dezactivați-l. | EN: This isn't perfectly working, if normal players get banned because of this, disable it.
SuperStars_AC.AntiGiveArmour = true

SuperStars_AC.AntiVehicleSpawn = false
SuperStars_AC.GarageList = { --ESX/QB-CORE: RO: Pune toate coordonatele garajului chiar aici. | EN: Place all of the garage coordinates right here.
	{x = 217.89, y = -804.99, z = 30.91},
}

SuperStars_AC.HospitalCoords = vector3(293.11,-582.1,43.19) --ESX/QB-CORE: RO: Pune coordonatele spitalului chiar aici. | EN: Put the coordinates of the hospital right here.

SuperStars_AC.BlacklistedWeapons = {
	"WEAPON_HAMMER",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG",
	"WEAPON_STINGER",
	"WEAPON_MINIGUN",
	"WEAPON_GRENADE",
	"WEAPON_BALL",
	"WEAPON_BOTTLE",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_GARBAGEBAG",
	"WEAPON_RAILGUN",
	"WEAPON_RAILPISTOL",
	"WEAPON_RAILGUN",
	"WEAPON_RAYPISTOL", 
	"WEAPON_RAYCARBINE", 
	"WEAPON_RAYMINIGUN",
	"WEAPON_DIGISCANNER",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_MARKSMANRIFLE_MK2",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_FIREWORK",
	"WEAPON_HOMINGLAUNCHER", 
	"WEAPON_SMG_MK2"
}
