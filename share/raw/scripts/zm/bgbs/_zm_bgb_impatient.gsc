#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm;
#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#insert scripts\zm\bgbs\_zm_bgb_impatient.gsh;

#insert scripts\zm\_zm_bgb.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace zm_bgb_impatient;


REGISTER_SYSTEM( BGB_IMPATIENT_NAME, &__init__, "bgb" )

function __init__()
{
	if ( !IS_TRUE( level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( BGB_IMPATIENT_NAME, BGB_IMPATIENT_LIMIT_TYPE, &event, undefined, undefined, undefined );
}


function event()
{
	self endon( "disconnect" );
	self endon( "bgb_update" );

	self waittill( "bgb_about_to_take_on_bled_out" );
	self thread special_revive();
}

function special_revive()
{
	self endon( "disconnect" );

	wait 1;

	// wait for the last zombie of the round to spawn
	while( level.zombie_total > 0 )
	{
		wait 0.05;
	}
	
	// respawn the player
	self zm::spectator_respawn_player();

	self bgb::do_one_shot_use();
}
