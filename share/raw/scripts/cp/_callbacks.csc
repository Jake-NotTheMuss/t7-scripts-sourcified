#using scripts\shared\ai_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\footsteps_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_driving_fx;
#using scripts\shared\weapons\_sticky_grenade;

#insert scripts\shared\shared.gsh;

#using scripts\cp\killstreaks\_ai_tank;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\_burnplayer;
#using scripts\cp\_callbacks;
#using scripts\cp\_claymore;
#using scripts\cp\_explosive_bolt;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_helicopter;
#using scripts\cp\killstreaks\_qrdrone;
#using scripts\cp\killstreaks\_rcbomb;
#using scripts\shared\util_shared;
#using scripts\cp\_vehicle;

#namespace callback;

REGISTER_SYSTEM( "callback", &__init__, undefined )

// Callback set up, clientside.
	
function __init__()
{
	level thread set_default_callbacks();
}

function set_default_callbacks()
{
	level.callbackPlayerSpawned = &playerspawned;
	level.callbackLocalClientConnect = &localclientconnect;
	level.callbackCreatingCorpse = &creating_corpse;
	level.callbackEntitySpawned = &entityspawned;
	//level.callbackAirSupport = &airsupport;
	//level.callbackDogSoundNotify = &dogs::play_dog_sound;
	level.callbackPlayAIFootstep = &footsteps::playaifootstep;
	level.callbackPlayLightLoopExploder = &exploder::playlightloopexploder;
	
	level._custom_weapon_CB_Func = &callback::spawned_weapon_type;
}

function localclientconnect( localClientNum )
{
	/# println( "*** Client script VM : Local client connect " + localClientNum ); #/
	
	if ( isdefined( level.characterCustomizationSetup ) )
	{
		[[ level.characterCustomizationSetup ]]( localclientnum );
	}
	if ( isdefined( level.weaponCustomizationIconSetup ) )
	{
		[[ level.weaponCustomizationIconSetup ]]( localclientnum );
	}
	
	callback::Callback( #"on_localclient_connect", localClientNum );
}

function playerspawned(localClientNum)
{
	self endon( "entityshutdown" );

	player = GetLocalPlayer( localClientNum );
	assert( isdefined( player ) );

	if ( isdefined( level.infraredVisionset ) )
	{
		player SetInfraredVisionset( level.infraredVisionset );
	}

	if ( self IsLocalPlayer() )
	{
		callback::Callback( #"on_localplayer_spawned", localClientNum );
	}

	
	callback::callback( #"on_player_spawned", localClientNum );	
}

function entityspawned(localClientNum)
{
	self endon( "entityshutdown" );

	if ( !isdefined( self.type ) )
	{
	/#	println( "Entity type undefined!" );	#/
		return;
	}
	
	if( self IsPlayer() )
	{
		if( isdefined( level._clientFaceAnimOnPlayerSpawned ) )
		{
			self thread [[level._clientFaceAnimOnPlayerSpawned]](localClientNum);
		}	
	}
		
	if ( self.type == "missile"  )
	{	
		if( isdefined( level._custom_weapon_CB_Func ) )
		{
			self thread [[level._custom_weapon_CB_Func]]( localClientNum );
		}
		
		//PrintLn( "entity spawned: weapon = " + self.weapon.name + "\n" );
		switch( self.weapon.name )
		{
		case "explosive_bolt":
			self thread _explosive_bolt::spawned( localClientNum );
			break;		
		case "claymore":
			self thread _claymore::spawned( localClientNum );
			break;		
		}
	}
	else if( self.type == "vehicle" || self.type == "helicopter" || self.type == "plane" )
	{	
		if( isdefined(level._customVehicleCBFunc) )
		{
			self thread [[level._customVehicleCBFunc]](localClientNum);
		}
	
		self thread vehicle::field_toggle_exhaustfx_handler( localClientNum, undefined, false, true );
		self thread vehicle::field_toggle_lights_handler( localClientNum, undefined, false, true );
		
		if ( self.vehicleclass == "plane" || self.vehicleclass == "helicopter" )
		{
			self thread vehicle::aircraft_dustkick();
		}
		else //if ( level.usetreadfx == 1 )
		{
			self thread driving_fx::play_driving_fx(localClientNum);
			self thread vehicle::rumble(localClientNum);
		}
		
		// if( self.type == "helicopter" )
		// {
		// 	self thread helicopter::startfx_loop( localClientNum );
		// }
	}
	else if( self.type == "actor" )
	{
		//Put actor on radar by default
		self enableOnRadar();

		if( isdefined(level._customActorCBFunc) )
		{
			self thread [[level._customActorCBFunc]](localClientNum);
		}
	}

}
/*
function airsupport( localClientNum, x, y, z, type, yaw, team, teamfaction, owner, exittype, time, height )
{
	pos = ( x, y, z );
	switch( teamFaction )
	{
		case "v":
			teamfaction = "vietcong";
			break;
		case "n":
		case "nva":
			teamfaction = "nva";
			break;
		case "j":
			teamfaction = "japanese";
			break;
		case "m":
			teamfaction = "marines";
			break;
		case "s":
			teamfaction = "specops";
			break;
		case "r":
			teamfaction = "russian";
			break;
		default:
		/#	println( "Warning: Invalid team char provided, defaulted to marines" );	#/
		/#	println( "Teamfaction received: " + teamFaction  + "\n" );	#/
			teamfaction = "marines";
			break;
	}
	
	switch( team )
	{
		case "x":
			team = "axis";
			break;
		case "l":
			team = "allies";
			break;
		case "r":
			team = "free";
			break;
		default:
		/#	println( "Invalid team used with playclientAirstike/napalm: " + team + "\n");	#/
			team = "allies";
			break;
	}
	
	data = spawnstruct();
	
	data.team = team;
	data.owner = owner;
	data.bombsite = pos;
	data.yaw = yaw;
	direction = ( 0, yaw, 0 );
	data.direction = direction;
	data.flyHeight = height;

	if ( type == "a" )
	{
		planeHalfDistance = 12000;
		data.planeHalfDistance = planeHalfDistance;
		data.startPoint = pos + VectorScale( anglestoforward( direction ), -1 * planeHalfDistance );
		data.endPoint = pos + VectorScale( anglestoforward( direction ), planeHalfDistance );
		data.planeModel = "t5_veh_air_b52";
		data.flyBySound = "null"; 
		data.washSound = "veh_b52_flyby_wash";
		data.apexTime = 6145;
		data.exitType = -1;
		data.flySpeed = 2000;
		data.flyTime = ( ( planeHalfDistance * 2 ) / data.flySpeed );
		planeType = "airstrike";
		//_airstrike::addPlaneEvent( localClientNum, planeType, data, time );	
	}
	else if ( type == "n" )
	{
		planeHalfDistance = 24000;
		data.planeHalfDistance = planeHalfDistance;
		data.startPoint = pos + VectorScale( anglestoforward( direction ), -1 * planeHalfDistance );
		data.endPoint = pos + VectorScale( anglestoforward( direction ), planeHalfDistance );
		data.planeModel = airsupport::getPlaneModel( teamFaction );
		data.flyBySound = "null"; 
		data.washSound = "evt_us_napalm_wash";
		data.apexTime = 2362;		
		data.exitType = exitType;
		data.flySpeed = 7000;
		data.flyTime = ( ( planeHalfDistance * 2 ) / data.flySpeed );
		planeType = "napalm";
		//_plane::addPlaneEvent( localClientNum, planeType, data, time );	
	}
	else
	{	
		/#
		println( "" );
		println( "Unhandled airsupport type, only A (airstrike) and N (napalm) supported" );
		println( type );
		println( "" );
		#/
		return;
	}	
}
*/
function creating_corpse( localClientNum, player )
{
}

function callback_stunned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self.stunned = newVal;
	
/#	PrintLn("stunned_callback");	#/
	
	if ( newVal )
	{
		self notify("stunned");
	}
	else
	{
		self notify("not_stunned");
	}
}

function callback_emp( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self.emp = newVal;
	
/#	PrintLn("emp_callback");	#/
	
	if ( newVal )
	{
		self notify("emp");
	}
	else
	{
		self notify("not_emp");
	}
}

function callback_proximity( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	self.enemyInProximity = newVal;
}
 