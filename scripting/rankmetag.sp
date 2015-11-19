#pragma semicolon  1
#include <sourcemod>
#include <rankme>
#include <cstrike>
#include <scp>
#include <morecolors>
#include <smlib>
#include <sdktools>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo = {
	name = "RankMe Clantag Chattag",
	author = "maoling",
	description = "",
	version = PLUGIN_VERSION,
	url = "tiara.moe"
};

public OnPluginStart()
{
	HookEvent("player_team", OnPlayerTeam);	
}

public OnAllPluginsLoaded()
{
	if(!LibraryExists("rankme"))
	{	
		LogError("RankMe not found. Plugin won't work.");		
	}
}

public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "rankme"))
	{
		LogMessage("RankMe Loaded.  Plugin is working.");
	}
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "rankme"))
	{
		LogError("RankMe Unloaded.  Plugin won't work.");
	}
}

public OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	RankMe_GetRank(GetClientOfUserId(GetEventInt(event, "userid")),RankConnectCallback);

	return Plugin_Continue;
}

public RankConnectCallback(client, rank, any:data)
{
	decl String:sBuffer[MAX_NAME_LENGTH];
	FormatEx(sBuffer, sizeof(sBuffer), "Top-%i", rank);				// Set Clan Tag with Rank , override 
	CS_SetClientClanTag(client, sBuffer); 
}

public Action:OnChatMessage(&client, Handle:recipients, String:name[], String:message[])
{
	int Points=RankMe_GetPoints(client);

	Format(name, 1024, "\x01 \x10[%i分] \x02%s", Points, name);     // Set Chat Tag with Score , Compatible with Store(Zephyrus) name color , name tag and message color
	CReplaceColorCodes(name, client, false, 1024);

	Format(message, 1024, "\x01 \x0C%s", message);
	CReplaceColorCodes(message, client, false, 1024);

	return Plugin_Handled;
}