#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_perks;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_utility;

#insert scripts\zm\bgbs\_zm_bgb_perkaholic.gsh;

#insert scripts\zm\_zm_bgb.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace zm_bgb_perkaholic;


REGISTER_SYSTEM( BGB_PERKAHOLIC_NAME, &__init__, "bgb" )

function __init__()
{
	if ( !IS_TRUE( level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( BGB_PERKAHOLIC_NAME, BGB_PERKAHOLIC_LIMIT_TYPE, &event, undefined, undefined, undefined );
}


function event()
{
	self endon( "disconnect" );
	self endon( "bgb_update" );

	self zm_utility::give_player_all_perks();

	self bgb::do_one_shot_use( true );

	wait 0.05;
}
