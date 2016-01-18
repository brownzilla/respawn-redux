#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#undef REQUIRE_EXTENSIONS
#define REQUIRE_EXTENSIONS

#define PREFIX "[Respawn] %t"
#define PLUGIN_VERSION "1.0"

new Handle:sm_respawn_enabled = INVALID_HANDLE;
int g_roundStartedTime = -1;

public Plugin:myinfo = {
  name = "Respawn Redux",
  author = "brownzilla",
  description = "Allows yourself to respawn on certain maps.",
  version = PLUGIN_VERSION,
  url = "http://sourcemod.net"
};

public void OnPluginStart()
{
  LoadTranslations("respawn_redux.phrases");
  sm_respawn_enabled = CreateConVar("sm_respawn_enabled", "1", "Enable or disable the plugin: 0 = Disabled | 1 = Enabled");
  RegConsoleCmd("sm_spawn", Command_Respawn, "Respawns a client");
  HookEvent("round_start", Event_RoundStart);
}

public Action Event_RoundStart(Handle event, const char[] name, bool dontBroadcast) {
  g_roundStartedTime = GetTime();
}

public int GetTotalRoundTime() {
  return GameRules_GetProp("m_iRoundTime");
}

public int GetCurrentRoundTime() {
  Handle h_freezeTime = FindConVar("mp_freezetime"); // Freezetime Handle
  int freezeTime = GetConVarInt(h_freezeTime); // Freezetime in seconds (5 by default)
  return (GetTime() - g_roundStartedTime) - freezeTime;
}

public Action Command_Respawn(int client, int args) {
  if (GetTotalRoundTime() - GetCurrentRoundTime() <= 1170) {
    PrintToChat(client, PREFIX, "unable");
    return Plugin_Handled;
  } else {
    if (GetConVarInt(sm_respawn_enabled) == 1) {
      if (!IsPlayerAlive(client)) {
        CS_RespawnPlayer(client);
        PrintToChat(client, PREFIX, "dead");
      } else {
        PrintToChat(client, PREFIX, "alive");
      }
    }
    return Plugin_Handled;
  }
}
