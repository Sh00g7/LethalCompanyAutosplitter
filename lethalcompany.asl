state("Lethal Company") {}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;

	dynamic[,] _settings =
	{
		{ null, "general", "General Splits" },
			{ "general", "quotaReached", "Split when the 'Quota Reached!' message appears" },

		{ null, "levels", "Level Splits" },
			{ "levels", "l0", "Experimentation" },
				{ "l0", "l0-d", "Split upon Death" },
				{ "l0", "l0-l", "Split upon Leaving" },
				{ "l0", "l0-h", "Split upon 100%ing" },
			{ "levels", "l1", "Assurance" },
				{ "l1", "l1-d", "Split upon Death" },
				{ "l1", "l1-l", "Split upon Leaving" },
				{ "l1", "l1-h", "Split upon 100%ing" },
			{ "levels", "l2", "Vow" },
				{ "l2", "l2-d", "Split upon Death" },
				{ "l2", "l2-l", "Split upon Leaving" },
				{ "l2", "l2-h", "Split upon 100%ing" },
			{ "levels", "l3", "Gordion" },
				{ "l3", "l3-d", "Split upon Death" },
				{ "l3", "l3-l", "Split upon Leaving" },
				{ "l3", "l3-h", "Split upon 100%ing" },
			{ "levels", "l4", "March" },
				{ "l4", "l4-d", "Split upon Death" },
				{ "l4", "l4-l", "Split upon Leaving" },
				{ "l4", "l4-h", "Split upon 100%ing" },
			{ "levels", "l5", "Rend" },
				{ "l5", "l5-d", "Split upon Death" },
				{ "l5", "l5-l", "Split upon Leaving" },
				{ "l5", "l5-h", "Split upon 100%ing" },
			{ "levels", "l6", "Dine" },
				{ "l6", "l6-d", "Split upon Death" },
				{ "l6", "l6-l", "Split upon Leaving" },
				{ "l6", "l6-h", "Split upon 100%ing" },
			{ "levels", "l7", "Offense" },
				{ "l7", "l7-d", "Split upon Death" },
				{ "l7", "l7-l", "Split upon Leaving" },
				{ "l7", "l7-h", "Split upon 100%ing" },
			{ "levels", "l8", "Titan" },
				{ "l8", "l8-d", "Split upon Death" },
				{ "l8", "l8-l", "Split upon Leaving" },
				{ "l8", "l8-h", "Split upon 100%ing" },

		{ null, "bestiary", "Bestiary Splits" },
			{ "bestiary", "creatures", "Scan a Creature" },
				{ "creatures", "c0", "Snare flea" },
				{ "creatures", "c1", "Bracken" },
				{ "creatures", "c2", "Thumper" },
				{ "creatures", "c3", "Eyeless dog" },
				{ "creatures", "c4", "Hoarding bug" },
				{ "creatures", "c5", "Hygrodere" },
				{ "creatures", "c6", "Forest keeper" },
				{ "creatures", "c7", "Coil-head" },
				{ "creatures", "c9", "Earth leviathan" },
				{ "creatures", "c10", "Jester" },
				{ "creatures", "c11", "Spore lizard" },
				{ "creatures", "c12", "Bunker spider" },
				{ "creatures", "c13", "Manticoil" },
				{ "creatures", "c14", "Circuit bee" },
				{ "creatures", "c15", "Roaming locust" },
				{ "creatures", "c16", "Baboon hawk" },
				{ "creatures", "c17", "Nutcracker" },
			{ "bestiary", "completeBestiary", "Complete Bestiary" }
	};

	vars.Helper.Settings.CreateCustom(_settings, false, null, 4, 1, 3);
	vars.Helper.AlertLoadless();
}

init
{
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["LevelId"] = mono.Make<int>("RoundManager", "Instance", "currentLevel", "levelID");

		vars.Helper["QuotaReached"] = mono.Make<bool>("HUDManager", "Instance", "displayingNewQuota");
		vars.Helper["Loading"] = mono.Make<bool>("HUDManager", "Instance", "loadingDarkenScreen", 0x10, 0x39); // UnityEngine.Object.m_CachedPtr.m_Active
		vars.Helper["TerminalText"] = mono.MakeString("HUDManager", "Instance", "terminalScript", "currentNode", "displayText");
		vars.Helper["TotalEnemies"] = mono.Make<int>("HUDManager", "Instance", "terminalScript", "enemyFiles", 0x18); // List<T>._size
		vars.Helper["ScannedEnemies"] = mono.MakeList<int>("HUDManager", "Instance", "terminalScript", "scannedEnemyIDs");

		vars.Helper["AllPlayersDead"] = mono.Make<bool>("StartOfRound", "Instance", "allPlayersDead");
		vars.Helper["ShipLeaving"] = mono.Make<bool>("StartOfRound", "Instance", "shipIsLeaving");

		return true;
	});
}

update
{
	current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
}

start
{
	return old.Loading && current.Loading;
}

split
{
	if (old.ScannedEnemies.Count < current.ScannedEnemies.Count)
	{
		int i = current.ScannedEnemies.Count - 1;
		return settings["c" + current.ScannedEnemies[i]];
	}

	if (old.TerminalText != current.TerminalText && current.TerminalText.StartsWith("BESTIARY", StringComparison.Ordinal)
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
	
	if (old.TerminalText != current.TerminalText && current.TerminalText.StartsWith("There are 0 objects", StringComparison.Ordinal))
	{
		return settings["l" + current.LevelId + "-h"];
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
