#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\shared\ai\zombie_death;

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_blockers;
#using scripts\zm\_zm_melee_weapon;
#using scripts\zm\_zm_pers_upgrades;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#insert scripts\zm\_zm_powerups.gsh;
#insert scripts\zm\_zm_utility.gsh;

#precache( "string", "ZOMBIE_POWERUP_BONUS_POINTS" );

#namespace zm_powerup_bonus_points_player;

REGISTER_SYSTEM( "zm_powerup_bonus_points_player", &__init__, undefined )

//-----------------------------------------------------------------------------------
// setup
//-----------------------------------------------------------------------------------
function __init__()
{
	zm_powerups::register_powerup( "bonus_points_player", &grab_bonus_points_player );
	if( ToLower( GetDvarString( "g_gametype" ) ) != "zcleansed" )
	{
		zm_powerups::add_zombie_powerup( "bonus_points_player", "zombie_z_money_icon", &"ZOMBIE_POWERUP_BONUS_POINTS", &zm_powerups::func_should_never_drop, POWERUP_ONLY_AFFECTS_GRABBER, !POWERUP_ANY_TEAM, !POWERUP_ZOMBIE_GRABBABLE );
	}
}

function grab_bonus_points_player( player )
{
	level thread bonus_points_player_powerup( self, player );
	player thread zm_powerups::powerup_vo( "bonus_points_solo" ); // TODO: Audio should uncomment this once the sounds have been set up
}

function bonus_points_player_powerup( item, player )
{
	points = RandomIntRange( 1, 25 ) * 100;

	if( isDefined( level.bonus_points_powerup_override ) )
	{
		points = [[ level.bonus_points_powerup_override ]]();
	}
	if( isDefined( item.bonus_points_powerup_override ) )
	{
		points = [[ item.bonus_points_powerup_override ]]();
	}
	
	if( !player laststand::player_is_in_laststand() && !(player.sessionstate == "spectator") )
	{
		player zm_score::player_add_points( "bonus_points_powerup", points );
	}
}
