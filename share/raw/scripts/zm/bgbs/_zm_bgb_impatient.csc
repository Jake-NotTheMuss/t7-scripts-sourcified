#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

#insert scripts\zm\bgbs\_zm_bgb_impatient.gsh;

#insert scripts\zm\_zm_bgb.gsh;
#insert scripts\zm\_zm_utility.gsh;

#namespace zm_bgb_impatient;


REGISTER_SYSTEM( BGB_IMPATIENT_NAME, &__init__, undefined )

function __init__()
{
	if ( !IS_TRUE( level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( BGB_IMPATIENT_NAME, BGB_IMPATIENT_LIMIT_TYPE );
}
