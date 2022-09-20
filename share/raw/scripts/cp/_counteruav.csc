#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace counteruav;

REGISTER_SYSTEM( "counteruav", &__init__, undefined )

function __init__()
{	
	clientfield::register( "scriptmover", "counteruav", VERSION_SHIP, 1, "int", &spawned, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function spawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if ( !isdefined( level.counteruavs ) )
	{
		level.counteruavs = [];
	}

	if ( !isdefined( level.counteruavs[localClientNum] ) )
	{
		level.counteruavs[localClientNum] = 0;
	}
		
	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( newVal )
	{
		level.counteruavs[localClientNum]++;
		self thread counteruav_think( localClientNum );
		player SetEnemyGlobalScrambler( true );
	}
	else
	{
		self notify( "counteruav_off" );
	}
}

function counteruav_think( localClientNum )
{
	self util::waittill_any( "entityshutdown", "counteruav_off" );

	level.counteruavs[localClientNum]--;

	if ( level.counteruavs[localClientNum] < 0 )
	{
		// reference counting gone bad
		level.counteruavs[localClientNum] = 0;
	}

	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( level.counteruavs[localClientNum] == 0 )
	{
		player SetEnemyGlobalScrambler( 0 );
	}
}
