#using scripts\shared\system_shared;

//REGISTER SHARED SYSTEMS - DO NOT REMOVE
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\player_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\water_surface;
#using scripts\shared\postfx_shared;
#using scripts\shared\blood;
#using scripts\shared\drown;
#using scripts\shared\_explode;

//Weapons
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_empgrenade;

#insert scripts\shared\shared.gsh;

#namespace load;

REGISTER_SYSTEM( "load", &__init__, undefined )

function __init__()
{
	/# level thread first_frame(); #/
	init_push_out_threshold();
}

/#

function first_frame()
{
	level.first_frame = true;
	wait 0.05;
	level.first_frame = undefined;
}

#/

function init_push_out_threshold()
{
	push_out_threshold = GetDvarFloat( "tu16_physicsPushOutThreshold", -1.0 );
	if ( push_out_threshold != -1.0 )
	{
		SetDvar( "tu16_physicsPushOutThreshold", 20.0 );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ART REVIEW - Set up the level to run for art/geo review (no event scripting) - should be called from load::main //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function art_review()
{
	if ( GetDvarString( "art_review" ) == "" )
	{
		SetDvar( "art_review", "0" );
	}
	
	if ( GetDvarString( "art_review" ) == "1" )
	{
		level waittill( "forever" );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !ART REVIEW                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
