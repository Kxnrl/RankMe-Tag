#pragma semicolon  1

#include <sourcemod>
#include <rankme>
#include <cstrike>
#pragma newdecls required


char g_szClantag[MAXPLAYERS+1][32];

public Plugin myinfo = 
{
	name = "RankMe Clantag",
	author = "maoling ( xQy )",
	description = "",
	version = "1.3.1",
	url = "http://steamcommunity.com/id/_xQy_/"
};

public void OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerEvent);	
	HookEvent("player_team", Event_PlayerEvent);	
}

public void OnAllPluginsLoaded()
{
	if(!LibraryExists("rankme"))
		SetFailState("RankMe not found. Plugin won't work.");		
}

public void OnLibraryRemoved(const char[] name)
{
	if(StrEqual(name, "rankme"))
		SetFailState("RankMe not found. Plugin won't work.");
}

public Action RankMe_OnPlayerLoaded(int client)
{
	RankMe_GetRank(client, GetClientRankCallback);
}

public Action Event_PlayerEvent(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(CanOverride(client)) OverwriteClanTag(client);
}

public void OnClientSettingsChanged(int client)
{
    if(CanOverride(client)) OverwriteClanTag(client);
}

public int GetClientRankCallback(int client, int rank, any data)
{
	if(rank == 0)
		strcopy(g_szClantag[client], 32, "NoRank");
	else
		Format(g_szClantag[client], 32, "Top-%d", rank);
}

void OverwriteClanTag(int client)
{
	CS_SetClientClanTag(client, g_szClantag[client]);
}

bool CanOverride(int client)
{
	if(!(1 <= client <= MaxClients))
		return false;
	
	if(!IsClientInGame(client))
		return false;
	
	if(GetClientTeam(client) <= 1)
		return false;

	return true;
}