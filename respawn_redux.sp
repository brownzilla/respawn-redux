#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#undef REQUIRE_EXTENSIONS
#include <colors>
#define REQUIRE_EXTENSIONS

#define PREFIX "[{green}Respawn{default}] %t"
#define PLUGIN_VERSION "1.0"

public Plugin:myinfo = {
  name = "Respawn Redux",
  author = "brownzilla",
  description = "Allows yourself to respawn on certain maps.",
  version = PLUGIN_VERSION,
  url = "http://sourcemod.net"
};

public OnPluginStart() {
  LoadTranslations("respawn_redux.phrases");
  RegConsoleCmd("sm_respawn", Command_Respawn, "Respawns a client");
}

public Action:Command_Respawn(client, args) {
  if (!IsPlayerAlive(client)) {
    CPrintToChat(client, PREFIX, "alive");
  } else {
    CS_RespawnPlayer(client);
    CPrintToChat(client, PREFIX, "dead");
  }
}
