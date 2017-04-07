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

public void OnAllPluginsLoaded()
{
	if(!LibraryExists("rankme"))
		SetFailState("RankMe not found. Plugin won't work.");
	
	CreateTimer(1.0, Timer_SetTag, _, TIMER_REPEAT);
}

public void OnLibraryRemoved(const char[] name)
{
	if(StrEqual(name, "rankme"))
		SetFailState("RankMe not found. Plugin won't work.");
}

public void OnClientConnected(int client)
{
	strcopy(g_szClantag[client], 32, "Loading...");
}

public Action RankMe_OnPlayerLoaded(int client)
{
	RankMe_GetRank(client, GetClientRankCallback);
}

public int GetClientRankCallback(int client, int rank, any data)
{
	if(rank == 0)
		strcopy(g_szClantag[client], 32, "No-Rank");
	else
		Format(g_szClantag[client], 32, "Top-%d", rank);
}

public Action Timer_SetTag(Handle timer)
{
	for(int client = 1; client <= MaxClients; ++client)
	{
		if(!IsClientInGame(client))
			continue;
		
		if(!GetClientTeam(client))
			continue;
		
		CS_SetClientClanTag(client, g_szClantag[client]);
	}
}