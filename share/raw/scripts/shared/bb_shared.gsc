#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;

#insert scripts\shared\shared.gsh;
#using scripts\shared\util_shared;
#namespace bb;



function init_shared()
{
	callback::on_start_gametype( &init );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************

function init()
{
	callback::on_connect( &player_init );
	callback::on_spawned( &on_player_spawned );
}

function player_init()
{
	self thread on_player_death();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_spawned()
{
	self endon("disconnect");

	self._bbData = [];
	
	// lives
	self._bbData[ "score" ] = 0;
	self._bbData[ "momentum" ] = 0;
	self._bbData[ "spawntime" ] = GetTime();

	// weapons
	self._bbData[ "shots" ] = 0;
	self._bbData[ "hits" ] = 0;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_disconnect()
{
	for(;;)
	{
		self waittill( "disconnect" );
		self commit_spawn_data();
		break;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_death()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "death" );
		self commit_spawn_data();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function commit_spawn_data() // self == player
{
	/#
	assert( isdefined( self._bbData ));
	#/
	if ( !isdefined( self._bbData ))
	{
		return;
	}

	bbprint( "mpplayerlives", "gametime %d spawnid %d lifescore %d lifemomentum %d lifetime %d name %s",
				GetTime(),
				getplayerspawnid( self ),
				self._bbData[ "score" ],
				self._bbData[ "momentum" ],
				(GetTime() - self._bbData[ "spawntime" ] ),
				self.name );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function commit_weapon_data( spawnid, currentWeapon, time0 ) // self == player
{
	/#
	assert( isdefined( self._bbData ));
	#/
	if ( !isdefined( self._bbData ))
	{
		return;
	}

	time1 = GetTime();
	blackBoxEventName = "mpweapons";

	if ( SessionModeIsCampaignGame() )
		blackBoxEventName = "cpweapons";
	else if ( SessionModeIsZombiesGame() )
		blackBoxEventName = "zmweapons";

	bbPrint( blackBoxEventName, "spawnid %d name %s duration %d shots %d hits %d", 
				spawnid, 
				currentWeapon.name, 
				time1 - time0, 
				self._bbData["shots"], 
				self._bbData["hits"] );

	self._bbData[ "shots" ] = 0;
	self._bbData[ "hits" ] = 0;
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function add_to_stat( statName, delta )
{
	if ( isdefined( self._bbData ) && isdefined( self._bbData[ statName ]))
	{
		self._bbData[ statName ] += delta;
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function recordBBDataForPlayer(breadcrumb_Table)//self == player
{
	if ( isdefined( level.gametype ) && level.gametype === "doa" )
	{
		return;
	}

	playerLifeIdx = self GetMatchRecordLifeIndex();
	if ( playerLifeIdx == -1 )
	{
		return;
	}

	movementType = "";
	stance = "";

	bbPrint( breadcrumb_Table, "gametime %d lifeIndex %d posx %d posy %d posz %d yaw %d pitch %d movetype %s stance %s", 
				GetTime(), 
				playerLifeIdx, 
				self.origin, 
				self.angles[0], 
				self.angles[1], 
				movementType,
				stance );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function recordBlackBoxBreadcrumbData(breadcrumb_Table)
{
	level endon( "game_ended" );

	if ( !SessionModeIsOnlineGame() || ( isdefined( level.gametype ) && level.gametype === "doa" ))
	{
		return;
	}

	while( 1 )
	{
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( IsAlive( player ) )
			{
				player recordBBDataForPlayer( breadcrumb_Table );
			}
		}
		wait( 2 );
	}
}
