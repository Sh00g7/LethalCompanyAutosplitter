state("Lethal Company") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ null, "general", true, "General Splits" },
			{ "general", "quotaReached", true, "Split when the 'Quota Reached!' message appears" },

		{ null, "levels", false, "Level Splits" },
			{ "levels", "l3", false, "The Company Building" },
				{ "l3", "l3-d", false, "Split upon Death" },
				{ "l3", "l3-l", false, "Split upon Leaving" },
				{ "l3", "l3-h", false, "Split upon 100%ing" },
			{ "levels", "l0", false, "Experimentation" },
				{ "l0", "l0-d", false, "Split upon Death" },
				{ "l0", "l0-l", false, "Split upon Leaving" },
				{ "l0", "l0-h", false, "Split upon 100%ing" },
			{ "levels", "l1", false, "Assurance" },
				{ "l1", "l1-d", false, "Split upon Death" },
				{ "l1", "l1-l", false, "Split upon Leaving" },
				{ "l1", "l1-h", false, "Split upon 100%ing" },
			{ "levels", "l2", false, "Vow" },
				{ "l2", "l2-d", false, "Split upon Death" },
				{ "l2", "l2-l", false, "Split upon Leaving" },
				{ "l2", "l2-h", false, "Split upon 100%ing" },
			{ "levels", "l8", false, "Offense" },
				{ "l8", "l8-d", false, "Split upon Death" },
				{ "l8", "l8-l", false, "Split upon Leaving" },
				{ "l8", "l8-h", false, "Split upon 100%ing" },
			{ "levels", "l4", false, "March" },
				{ "l4", "l4-d", false, "Split upon Death" },
				{ "l4", "l4-l", false, "Split upon Leaving" },
				{ "l4", "l4-h", false, "Split upon 100%ing" },
			{ "levels", "l6", false, "Rend" },
				{ "l6", "l6-d", false, "Split upon Death" },
				{ "l6", "l6-l", false, "Split upon Leaving" },
				{ "l6", "l6-h", false, "Split upon 100%ing" },
			{ "levels", "l7", false, "Dine" },
				{ "l7", "l7-d", false, "Split upon Death" },
				{ "l7", "l7-l", false, "Split upon Leaving" },
				{ "l7", "l7-h", false, "Split upon 100%ing" },
			{ "levels", "l9", false, "Titan" },
				{ "l9", "l9-d", false, "Split upon Death" },
				{ "l9", "l9-l", false, "Split upon Leaving" },
				{ "l9", "l9-h", false, "Split upon 100%ing" },
			{ "levels", "l5", false, "Adamance" }, 
				{ "l5", "l5-d", false, "Split upon Death" },
				{ "l5", "l5-l", false, "Split upon Leaving" },
				{ "l5", "l5-h", false, "Split upon 100%ing" },
			{ "levels", "l10", false, "Artifice" },
				{ "l10", "l10-d", false, "Split upon Death" },
				{ "l10", "l10-l", false, "Split upon Leaving" },
				{ "l10", "l10-h", false, "Split upon 100%ing" },
			{ "levels", "l12", false, "Embrion" },
				{ "l12", "l12-d", false, "Split upon Death" },
				{ "l12", "l12-l", false, "Split upon Leaving" },
				{ "l12", "l12-h", false, "Split upon 100%ing" },

		{ null, "bestiary", false, "Bestiary Splits" },
			{ "bestiary", "creatures", false, "Scan a Creature" },
				{ "creatures", "c0", false, "Snare flea" },
				{ "creatures", "c1", false, "Bracken" },
				{ "creatures", "c2", false, "Thumper" },
				{ "creatures", "c3", false, "Eyeless dog" },
				{ "creatures", "c4", false, "Hoarding bug" },
				{ "creatures", "c5", false, "Hygrodere" },
				{ "creatures", "c6", false, "Forest keeper" },
				{ "creatures", "c7", false, "Coil-head" },
				{ "creatures", "c9", false, "Earth leviathan" },
				{ "creatures", "c10", false, "Jester" },
				{ "creatures", "c11", false, "Spore lizard" },
				{ "creatures", "c12", false, "Bunker spider" },
				{ "creatures", "c13", false, "Manticoil" },
				{ "creatures", "c14", false, "Circuit bee" },
				{ "creatures", "c15", false, "Roaming locust" },
				{ "creatures", "c16", false, "Baboon hawk" },
				{ "creatures", "c17", false, "Nutcracker" },
			{ "bestiary", "completeBestiary", false, "Complete Bestiary" },

		{ null, "killing", false, "Kill% Splits" },
			{ "killing", "indoorskills", false, "Indoors Creatures" },
				{ "indoorskills", "indpower3", false, "Bunker Spider/Thumper/Bracken" },
				{ "indoorskills", "indpower1", false, "Snare Flea/Hoarding Bug/Nutcracker/Masked" },
			{ "killing", "daytimekills", false, "Daytime Creatures" },
				{ "daytimekills", "daypower1", false, "Manticoil" },
			{ "killing", "nighttimekills", false, "Nighttime Creatures" },
				{ "nighttimekills", "nightpower2", false, "Eyeless Dog" },
				{ "nighttimekills", "nightpower1", false, "Baboon Hawk" }
	};

	vars.Helper.Settings.CreateCustom(_settings, 4, 1, 2, 3);
	vars.Helper.AlertLoadless();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["LevelId"] = mono.Make<int>("RoundManager", "Instance", "currentLevel", "levelID");

		vars.Helper["QuotaReached"] = mono.Make<bool>("HUDManager", "Instance", "displayingNewQuota");
		vars.Helper["Loading"] = mono.Make<bool>("HUDManager", "Instance", "loadingDarkenScreen", 0x10, 0x39); // UnityEngine.Object.m_CachedPtr.m_Active
		vars.Helper["TerminalText"] = mono.MakeString("HUDManager", "Instance", "terminalScript", "currentText");
		vars.Helper["TotalEnemies"] = mono.Make<int>("HUDManager", "Instance", "terminalScript", "enemyFiles", 0x18); // List<T>._size
		vars.Helper["ScannedEnemies"] = mono.MakeList<int>("HUDManager", "Instance", "terminalScript", "scannedEnemyIDs");

		vars.Helper["AllPlayersDead"] = mono.Make<bool>("StartOfRound", "Instance", "allPlayersDead");
		vars.Helper["ShipLeaving"] = mono.Make<bool>("StartOfRound", "Instance", "shipIsLeaving");

		vars.Helper["UsingItem"] = mono.Make<bool>("RoundManager", "Instance", "playersManager", "localPlayerController", "activatingItem");
		vars.Helper["ItemCd"] = mono.Make<float>("RoundManager", "Instance", "playersManager", "localPlayerController", "currentlyHeldObjectServer", "currentUseCooldown");

		vars.Helper["IndoorsPower"] = mono.Make<int>("RoundManager", "Instance", "currentEnemyPower");
		vars.Helper["NightPower"] = mono.Make<int>("RoundManager", "Instance", "currentOutsideEnemyPower");
		vars.Helper["DayPower"] = mono.Make<int>("RoundManager", "Instance", "currentDaytimeEnemyPower");

		vars.Helper["PlayerCount"] = mono.Make<int>("GameNetworkManager", "Instance", "connectedPlayers");
		vars.Helper["EnemySpawning"] = mono.Make<bool>("RoundManager", "Instance", "isSpawningEnemies");

		return true;
	});
}

update
{
	current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
}

start
{
	return old.Loading && !current.Loading;
}

split
{
	if (old.ScannedEnemies.Count < current.ScannedEnemies.Count)
	{
		int i = current.ScannedEnemies.Count - 1;
		return settings["c" + current.ScannedEnemies[i]];
	}

	if (old.TerminalText != current.TerminalText && current.TerminalText.Contains("BESTIARY")
		&& current.ScannedEnemies.Count == current.TotalEnemies)
	{
		return settings["completeBestiary"];
	}

	if (!old.QuotaReached && current.QuotaReached && settings["quotaReached"])
	{
		return true;
	}

	if (!old.AllPlayersDead && current.AllPlayersDead)
	{
		return settings["l" + current.LevelId + "-d"];
	}

	if (!old.ShipLeaving && current.ShipLeaving)
	{
		return settings["l" + current.LevelId + "-l"];
	}
	
	if (old.TerminalText != current.TerminalText && current.TerminalText.Contains("There are 0 objects"))
	{
		return settings["l" + current.LevelId + "-h"];
	}

	if (((old.UsingItem != current.UsingItem) && old.UsingItem) || ((old.ItemCd < current.ItemCd) && current.ItemCd > 0) || (current.PlayerCount > 1 && current.EnemySpawning))
	{
		if (old.IndoorsPower > current.IndoorsPower)
    		{
			int pLoss = old.IndoorsPower - current.IndoorsPower;
        		return settings["indpower" + pLoss];
    		}

		if (old.NightPower > current.NightPower)
    		{
			int pLoss = old.NightPower - current.NightPower;
        		return settings["nightpower" + pLoss];
    		}

		if (old.DayPower > current.DayPower)
    		{
			int pLoss = old.DayPower - current.DayPower;
        		return settings["daypower" + pLoss];
    		}
	}
}

reset
{
	return old.Scene != "MainMenu" && current.Scene == "MainMenu";
}

isLoading
{
	return current.Loading;
}
