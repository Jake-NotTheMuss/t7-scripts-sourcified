#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;


function main()
{
	clientfield::register( "world", "light_show", VERSION_DLC5, 2, "int", &choose_light_show, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function choose_light_show( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	switch( newVal )
	{
		case 1:
			level.light_on_color		= ( 2, 2, 2 );
			level.light_off_color		= ( .25, .25, .25 );
			break;

		case 2:
			level.light_on_color		= ( 2, .1, .1 );
			level.light_off_color		= ( .5, .1, .1 );
			break;

		case 3:
			level.light_on_color		= ( .1, 2, .1 );
			level.light_off_color		= ( .1, .5, .1 );
			break;

		default:
			level.light_on_color		= undefined;
			level.light_off_color		= undefined;
			break;
	}
}
