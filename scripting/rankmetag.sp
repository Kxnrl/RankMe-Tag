#pragma semicolon  1

#include <sourcemod>
#include <rankme>
#include <cstrike>

#define PLUGIN_VERSION " 1.3 - [CG] Community Version "

new String:g_ClientRank[MAXPLAYERS + 1][64];
new bool:g_bClientRank[MAXPLAYERS+1];

public Plugin myinfo = 
{
	name = "RankMe Clantag",
	author = "maoling ( shAna.xQy )",
	description = "",
	version = PLUGIN_VERSION,
	url = "http://steamcommunity.com/id/shAna_xQy/"
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

public Action:RankMe_OnPlayerLoaded(client)
{
	
	RankMe_GetRank(client, RankConnectCallback);
	
	return Plugin_Continue;
}

public OnPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client != 0)
	{
		if(IsClientInGame(client) && GetClientTeam(client) > 1)
		{
			OverwriteClanTag(client);
		}
	}
}

public OnClientSettingsChanged(client)
{
    if(IsClientInGame(client) && GetClientTeam(client) > 1)
	{
		OverwriteClanTag(client);
	}
}

public RankConnectCallback(client, rank, any:data)
{
	if(rank == 0)
	{
		g_bClientRank[client] = false;
	}
	else
	{
		IntToString(rank, g_ClientRank[client], sizeof(g_ClientRank[]));
		g_bClientRank[client] = true;
	}
}

public OverwriteClanTag(client)
{
	if(!g_bClientRank[client])
	{
		decl String:sBuffer[MAX_NAME_LENGTH];
		FormatEx(sBuffer, sizeof(sBuffer), "未统计");
		CS_SetClientClanTag(client, sBuffer);
	}
	else
	{
		decl String:sBuffer[MAX_NAME_LENGTH];
		FormatEx(sBuffer, sizeof(sBuffer), "Top-%s", g_ClientRank[client]);
		CS_SetClientClanTag(client, sBuffer);
	}
}
