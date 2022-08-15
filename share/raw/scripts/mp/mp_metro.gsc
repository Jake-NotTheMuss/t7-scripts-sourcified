#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;

#using scripts\shared\compass;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_metro_fx;
#using scripts\mp\mp_metro_sound;
#using scripts\mp\mp_metro_train;

function main()
{
	precache();

	SetDvar( "phys_buoyancy", true );
	
	clientfield::register( "scriptmover", "mp_metro_train_timer", VERSION_SHIP, 1, "int" );
	
	mp_metro_fx::main();
	mp_metro_sound::main();
	
	load::main();

	//compass map function, uncomment when adding the minimap
	compass::setupMiniMap("compass_map_mp_metro");

	SetDvar( "compassmaxrange", "2100" );	// Set up the default range of the compass

	// Stockpile hub points
	level.cleanDepositPoints = Array ( ( -399.059, 1.39783, -47.875 ),
                                  ( -1539.2, -239.678, -207.875 ),
                                  ( 878.216, -0.543464, -47.875 ),
                                  ( 69.9086, 1382.49, 0.125 ) );
	
	if ( GetGametypeSetting( "allowMapScripting" ) )
	{
		level thread mp_metro_train::init();
	}
	
	/# 
		level thread devgui_metro();
		execdevgui( "devgui/mp/map_mp_metro" );
	#/
}

function precache()
{
	// DO ALL PRECACHING HERE
}


/#

function devgui_metro()
{	
	SetDvar( "devgui_notify", "" );

	for ( ;; )
	{
		wait( 0.5 );

		devgui_string = GetDvarString( "devgui_notify" );

		switch( devgui_string )
		{
		case "":
			break;

		case "train_start_1":
			level notify( "train_start_1" );
			break;
			
		case "train_start_2":
			level notify( "train_start_2" );
			break;
			
		default:
			break;
		}

		if ( GetDvarString( "devgui_notify" ) != "" )
		{
			SetDvar( "devgui_notify", "" );
		}
	}
}

#/
