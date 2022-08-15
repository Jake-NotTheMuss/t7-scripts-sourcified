#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons_shared;

#insert scripts\shared\shared.gsh;

#using scripts\shared\bots\_bot_combat;
#using scripts\shared\bots\_bot;

#using scripts\zm\_zm_weapons;

//Must match code (hkai_influence.h)
	//bullet impacts
	//ai positions
	//player positions






#namespace zm_bot;

REGISTER_SYSTEM( "zm_bot", &__init__, undefined )

function __init__()
{
/#	PrintLn( "ZM >> Zombiemode Server Scripts Init (_zm_bot.gsc)" );	#/
/#
	level.onBotSpawned = &on_bot_spawned;
	level.getBotThreats = &bot_combat::get_ai_threats;
	level.botPreCombat = &bot::coop_pre_combat;
	level.botPostCombat = &bot::coop_post_combat;
	level.botIdle = &bot::follow_coop_players;
	level.botDevguiCmd = &bot::coop_bot_devgui_cmd;
	thread debug_coop_bot_test();
#/
}

/#
function debug_coop_bot_test()
{
	botCount = 0;

	AddDebugCommand( "set bot_AllowMovement 1; set bot_PressAttackBtn 1; set bot_PressMeleeBtn 1; set scr_botsAllowKillstreaks 0; set bot_AllowGrenades 1" );

	while ( true )
	{
		if ( GetDvarInt( "debug_coop_bot_joinleave" ) > 0 )
		{
			while ( GetDvarInt( "debug_coop_bot_joinleave" ) > 0 )
			{
				if ( botCount > 0 && RandomInt( 100 ) > 60 )
				{
					AddDebugCommand( "set devgui_bot remove" );
					botCount--;
					DebugMsg( "Bot is being removed.   Count=" + botCount );
				}
				else if ( botCount < GetDvarInt( "debug_coop_bot_joinleave" ) && RandomInt( 100 ) > 50 )
				{
					AddDebugCommand( "set devgui_bot add" );
					botCount++;
					DebugMsg( "Bot is being added.  Count=" + botCount );
				}

				wait RandomIntRange( 1, 3 );
			}
		}
		else
		{
			//remove any bots that are left after this is turned off
			while ( botCount > 0 )
			{
				AddDebugCommand( "set devgui_bot remove" );
				botCount--;
				DebugMsg( "Bot is being removed.   Count=" + botCount );

				wait 1; // delay the disconnections
			}
		}

		wait 1; // occasionally check the dvar
	}
}

#/

function on_bot_spawned()
{
	/#
		host = bot::get_host_player();
		loadout = host zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout( loadout );
	#/
}

function debugMsg( str_txt )
{
	/#
		IPrintLnBold( str_txt );
		if ( isdefined( level.name ) ) //not defined for testmaps
		{
			PrintLn( "[" + level.name + "] " + str_txt );
		}
	#/
}
