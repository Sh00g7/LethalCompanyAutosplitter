state("Lethal Company")
{
	bool firstTimeSpawningEnemies: "UnityPlayer.dll", 0x01BE9D00, 0x1A8, 0x198, 0x1B8, 0x78, 0x60, 0xF0, 0x2B0;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
	vars.Helper.LoadSceneManager = true;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["loading"] = mono.Make<bool>("HUDManager", "Instance", "loadingDarkenScreen", 0x10, 0x39);
		vars.Helper["displayingNewQuota"] = mono.Make<bool>("HUDManager", "Instance", "displayingNewQuota");

        return true;
    });
}

update
{
    current.Scene = vars.Helper.Scenes.Active.Name ?? old.Scene;
}

start
{
	if((current.firstTimeSpawningEnemies == true) && (old.firstTimeSpawningEnemies == false)){
		return true;
	}
}

split
{
	if((current.displayingNewQuota == true) && (old.displayingNewQuota == false)){
		return true;
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