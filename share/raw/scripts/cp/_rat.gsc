#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\rat_shared;

#insert scripts\shared\shared.gsh;

#using scripts\cp\_util;

/#
#namespace rat;

REGISTER_SYSTEM( "rat", &__init__, undefined )

function __init__()
{
	rat_shared::init();
	
	// Set up common function for the shared rat script commands to call
	level.rat.common.gethostplayer = &util::getHostPlayer;

}
#/	



