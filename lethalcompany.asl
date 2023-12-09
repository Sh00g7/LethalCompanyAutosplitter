state("Lethal Company")
{
	string50 currentText: "UnityPlayer.dll", 0x01BE9D00, 0x1A8, 0x198, 0x1B8, 0x78, 0x60, 0xC8, 0x1A;
	byte scanCount: "UnityPlayer.dll", 0x01BE9D00, 0x1A8, 0x198, 0x1B8, 0x78, 0x60, 0x128, 0x18;
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;
	
	settings.Add("bestiary", false, "Bestiary%");
	settings.SetToolTip("bestiary", "Splits when checking the bestiary in the terminal and having found all creatures, only tick if you're running Bestiary%");
	
	settings.Add("scanSplits", false, "Split when new creature is scanned", "bestiary");
	settings.SetToolTip("scanSplits", "Splits every time a new creature is scanned (you will need 17 splits total)");
	
	settings.Add("levelHundo", false, "Level 100%");
	settings.SetToolTip("levelHundo", "Splits when scanning for items in the terminal and finding none, only tick if you're running Level 100%");
	
	settings.Add("death", false, "Death%");
	settings.SetToolTip("death", "Splits on death, only tick if you're running Death%");
	
	settings.Add("experimentation", false, "Experimentation", "death");
	settings.SetToolTip("experimentation", "Split when dying on Experimentation");
	
	settings.Add("assurance", false, "Assurance", "death");
	settings.SetToolTip("assurance", "Split when dying on Assurance");
	
	settings.Add("vow", false, "Vow", "death");
	settings.SetToolTip("vow", "Split when dying on Vow");
	
	settings.Add("offense", false, "Offense", "death");
	settings.SetToolTip("offense", "Split when dying on Offense");
	
	settings.Add("march", false, "March", "death");
	settings.SetToolTip("march", "Split when dying on March");
	
	settings.Add("rend", false, "Rend", "death");
	settings.SetToolTip("rend", "Split when dying on Rend");
	
	settings.Add("dine", false, "Dine", "death");
	settings.SetToolTip("dine", "Split when dying on Dine");
	
	settings.Add("titan", false, "Titan", "death");
	settings.SetToolTip("titan", "Split when dying on Titan");
}

init
{
	if (timer.CurrentTimingMethod == TimingMethod.RealTime) {
		var timingMessage = MessageBox.Show(
			"Lethal Company speedrunning rules require the timer to be set to Game Time.\n"+
			"LiveSplit is currently set to show Real Time (RTA).\n"+
			"It will now be changed to Game Time.\n"+
			"(You can change it back to Real Time with Right Click > Compare Against > Real Time)",
			"Lethal Company Autosplitter",
			MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
		
		timer.CurrentTimingMethod = TimingMethod.GameTime;
	}
	vars.shouldStart = 0;
	
	vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
	{
		vars.Helper["loading"] = mono.Make<bool>("HUDManager", "Instance", "loadingDarkenScreen", 0x10, 0x39);
		vars.Helper["displayingNewQuota"] = mono.Make<bool>("HUDManager", "Instance", "displayingNewQuota");
		vars.Helper["allPlayersDead"] = mono.Make<bool>("StartOfRound", "Instance", "allPlayersDead");
		vars.Helper["PlanetName"] = mono.MakeString("StartOfRound", "Instance", "currentLevel", "PlanetName");

		return true;
	});
}

update
{
	current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
	
	if (current.loading == true)
	{
		vars.shouldStart = 1;
	}
	
	print(current.PlanetName);
}

start
{
	if (current.loading == false && vars.shouldStart == 1)
	{
		vars.shouldStart = 0;
		return true;
	}
}

split
{
	if (current.displayingNewQuota == true && old.displayingNewQuota == false && settings["bestiary"] == false)
	{
		return true;
	}
	
	if (settings["bestiary"] == true && settings["scanSplits"] == true && !current.scanCount.Equals(old.scanCount))
	{
		return true;
	}
	
	if (settings["bestiary"] == true && current.currentText.StartsWith("BESTIARY") && !old.currentText.StartsWith("BESTIARY") && current.scanCount.Equals(0x10))
	{
		return true;
	}
	
	if (settings["levelHundo"] == true && current.currentText.StartsWith("There are 0 objects"))
	{
		return true;
	}
	
	if (settings["death"] == true && current.allPlayersDead == true)
	{
		if (settings["experimentation"] == true && current.PlanetName.Contains("Experimentation"))
		{
			return true;
		}
		if (settings["assurance"] == true && current.PlanetName.Contains("Assurance"))
		{
			return true;
		}
		if (settings["vow"] == true && current.PlanetName.Contains("Vow"))
		{
			return true;
		}
		if (settings["offense"] == true && current.PlanetName.Contains("Offense"))
		{
			return true;
		}
		if (settings["march"] == true && current.PlanetName.Contains("March"))
		{
			return true;
		}
		if (settings["rend"] == true && current.PlanetName.Contains("Rend"))
		{
			return true;
		}
		if (settings["dine"] == true && current.PlanetName.Contains("Dine"))
		{
			return true;
		}
		if (settings["titan"] == true && current.PlanetName.Contains("Titan"))
		{
			return true;
		}
	}
}

reset
{
	return old.Scene != current.Scene
		&& current.Scene == "MainMenu";
}

isLoading
{
	return current.loading;
}
