#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_unitrigger;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;
#using scripts\zm\_zm_zonemgr;

#precache( "fx", "zombie/fx_weapon_box_marker_zod_zmb" );
#precache( "fx", "zombie/fx_weapon_box_marker_fl_zod_zmb" );
#precache( "fx", "tools/fx_null" );

#namespace zm_magicbox_zod;

function init()
{
	RegisterClientField( "zbarrier", "magicbox_initial_fx", VERSION_SHIP, 1, "int" );
	RegisterClientField( "zbarrier", "magicbox_amb_sound", VERSION_SHIP, 1, "int" );
	RegisterClientField( "zbarrier", "magicbox_open_fx", VERSION_SHIP, 2, "int" );

	// custom fx
	//Magic Box
	level._effect["box_light_marker"] 	= "zombie/fx_weapon_box_marker_zod_zmb";
	level._effect["box_light_flare"] 		= "zombie/fx_weapon_box_marker_fl_zod_zmb";
	level._effect["poltergeist"]				= "tools/fx_null"; // no fx for this

	level.chest_joker_model = "p7_zm_zod_magic_box_tentacle_teddy";
	
	level.chest_joker_custom_movement = &custom_joker_movement;
	level.custom_magic_box_timer_til_despawn = &custom_magic_box_timer_til_despawn;
	level.custom_magic_box_do_weapon_rise = &custom_magic_box_do_weapon_rise;
	level.custom_magic_box_weapon_wait = &custom_magic_box_weapon_wait;
	level.custom_pandora_show_func = &custom_pandora_show_func;
	level.custom_treasure_chest_glowfx = &custom_magic_box_fx;

	level.custom_firesale_box_leave = 1;
	level.custom_magicbox_float_height = 40;

	level.magic_box_zbarrier_state_func = &set_magic_box_zbarrier_state;

	level thread handle_fire_sale();
	level thread custom_magicbox_host_migration();
}

//override for the default bear movement
function custom_joker_movement()
{
	//record the weapon model origin and delete it, it could have parts hidden based on what weapon spawned
	v_origin = self.weapon_model.origin - ( 0, 0, 5 );
	self.weapon_model Delete();

	//spawn a fresh new model with everything correct
	m_lock = Spawn( "script_model", v_origin );
	m_lock SetModel( level.chest_joker_model );
	m_lock.angles = self.angles + ( 0, 270, 0 );
	m_lock playSound ("zmb_hellbox_bear");

	//let the pain linger for a while
	wait .5;
	level notify("weapon_fly_away_start");
	wait 1;

	//start spinning fast
	m_lock RotateYaw( 3000, 4.5, 4.5 );
	
	//wait for it to get real fast
	wait 3;

	//move up in the z a bit

	v_angles = AnglesToForward( self.angles - (90, 90, 0) );

	m_lock MoveTo( m_lock.origin + 35 * v_angles, 1.5, 1 );
	m_lock waittill( "movedone" );
	
	//fast move down into the box
	m_lock MoveTo( m_lock.origin + (-100 * v_angles), 0.5, 0.5 );
	m_lock waittill( "movedone" );
	
	//and it's gone
	m_lock Delete();

	self notify( "box_moving" );
	level notify("weapon_fly_away_end");
}

function custom_magic_box_timer_til_despawn( magic_box )
{
	self endon( "kill_weapon_movement" );
	
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
	putbacktime = 12;
	v_float = AnglesToUp( self.angles ) * level.custom_magicbox_float_height;
	self MoveTo( self.origin - ( v_float * 0.4 ), putbacktime, ( putbacktime * 0.5 ) );
	wait( putbacktime );

	if( isdefined( self ) )
	{
		self Delete();
	}
}

function custom_magic_box_fx()
{
}

function custom_pandora_fx_func()
{
	self endon("death");

	self.pandora_light = util::spawn_model( "tag_origin", self.zbarrier.origin, VectorScale((-1, 0, -1), 90) );

	if ( !IS_TRUE( level._box_initialized ) )
	{
		level flag::wait_till( "start_zombie_round_logic" );
		level._box_initialized = true;
	}

	wait 1;
	if ( isdefined( self.pandora_light ) )
	{
		PlayFXOnTag( level._effect["box_light_marker"], self.pandora_light, "tag_origin" );
	}
}

function custom_pandora_show_func()
{
	if ( !isdefined( self.pandora_light ) )
	{
		if ( !isdefined( level.pandora_fx_func ) )
			level.pandora_fx_func = &custom_pandora_fx_func;

		self thread [[ level.pandora_fx_func ]]();
	}

	PlayFX( level._effect["box_light_flare"], self.pandora_light.origin );
}

function custom_magic_box_weapon_wait()
{
	wait 0.5;
}

function set_magic_box_zbarrier_state( state )
{
	for ( i = 0; i < self GetNumZBarrierPieces(); i++)
	{
		self HideZBarrierPiece(i);
	}

	self notify("zbarrier_state_change");

	switch( state )
	{
		case "away":
			self ShowZBarrierPiece(0);
			self.state = "away";
			self.owner.is_locked = false;
			break;
		case "arriving":
			self ShowZBarrierPiece(1);
			self thread magic_box_arrives();
			self.state = "arriving";
			break;
		case "initial":
			self ShowZBarrierPiece(1);
			self thread magic_box_initial();
			thread zm_unitrigger::register_static_unitrigger( self.owner.unitrigger_stub, &zm_magicbox::magicbox_unitrigger_think );
			self.state = "close";
			break;
		case "open":
			self ShowZBarrierPiece(2);
			self thread magic_box_opens();
			self.state = "open";
			break;
		case "close":
			self ShowZBarrierPiece(2);
			self thread magic_box_closes();
			self.state = "close";
			break;
		case "leaving":
			self ShowZBarrierPiece(1);
			self thread magic_box_leaves();
			self.state = "leaving";
			self.owner.is_locked = false;
			break;
		default:
			if ( IsDefined( level.custom_magicbox_state_handler ) )
			{
				self [[ level.custom_magicbox_state_handler ]]( state );
			}
			break;
	}
}

function magic_box_initial()
{
	level flag::wait_till( "all_players_spawned" );
	level flag::wait_till( "zones_initialized" );
	self SetZBarrierPieceState(1, "open");
	self clientfield::set( "magicbox_amb_sound", 1 );
	self clientfield::set( "magicbox_open_fx", 1 );
}

function magic_box_arrives()
{
	self SetZBarrierPieceState(1, "opening");
	while(self GetZBarrierPieceState(1) == "opening")
	{
		wait (0.05);
	}
	self notify("arrived");
	self.state = "close";
	
	self clientfield::set( "magicbox_amb_sound", 1 );
}

function magic_box_leaves()
{
	self clientfield::set( "magicbox_open_fx", 0 );
	self SetZBarrierPieceState(1, "closing");

	//SOUND - Shawn J
	self playsound ("zmb_hellbox_rise");
	while(self GetZBarrierPieceState(1) == "closing")
	{
		wait (0.1);
	}
	self notify("left");
	
	self clientfield::set( "magicbox_open_fx", 2 );
	self clientfield::set( "magicbox_amb_sound", 0 );

	//determines if fire sale can be dug up
	if ( !IS_TRUE( level.dig_magic_box_moved ) )
	{
		level.dig_magic_box_moved = true;
	}

}

function magic_box_opens()
{
	self clientfield::set( "magicbox_open_fx", 1 );
	self SetZBarrierPieceState(2, "opening");
	self PlaySound( "zmb_hellbox_open" );
	while(self GetZBarrierPieceState(2) == "opening")
	{
		wait (0.1);
	}
	self notify("opened");
	self thread magic_box_open_idle(); // play the idle animation once the magic box is finished opening
}

function magic_box_open_idle()
{
	self endon("stop_open_idle");

	// hide the standing opening/closing zbarrier piece
	self HideZBarrierPiece(2);
	
	// show the idle animation zbarrier piece, and set its animation
	self ShowZBarrierPiece(5);
	while( true )
	{
		self SetZBarrierPieceState(5, "opening");
		while ( self GetZBarrierPieceState(5) != "open" )
		{
			wait 0.05;
		}
	}
}

function magic_box_closes()
{
	self notify("stop_open_idle");

	// hide the idle animation zbarrier piece; show the standard opening/closing zbarrier piece
	self HideZBarrierPiece(5);
	self ShowZBarrierPiece(2);

	self SetZBarrierPieceState(2, "closing");
	self PlaySound( "zmb_hellbox_close" );
	self clientfield::set( "magicbox_open_fx", 0 );
	while(self GetZBarrierPieceState(2) == "closing")
	{
		wait (0.1);
	}
	self notify("closed");
}

function custom_magic_box_do_weapon_rise()
{
	self endon("box_hacked_respin");
	
	wait 0.5; // waiting so that the portal effect can start playing

	self SetZBarrierPieceState(3, "closed");
	self SetZBarrierPieceState(4, "closed");
	
	util::wait_network_frame();

	self ZBarrierPieceUseBoxRiseLogic(3);
	self ZBarrierPieceUseBoxRiseLogic(4);
	
	self ShowZBarrierPiece(3);
	self ShowZBarrierPiece(4);
	self SetZBarrierPieceState(3, "opening");
	self SetZBarrierPieceState(4, "opening");

	while(self GetZBarrierPieceState(3) != "open")
	{
		wait(0.5);
	}

	self HideZBarrierPiece(3);
	self HideZBarrierPiece(4);
}

//fire sales do not enter the leave state so the fx must be manually removed
function handle_fire_sale()
{
	while( 1 )
	{
		str_firesale_status = level util::waittill_any_return( "fire_sale_off", "fire_sale_on" );
		
		for( i = 0; i < level.chests.size; i++ )
		{
			if( level.chest_index != i && IsDefined(level.chests[i].was_temp))
			{
				if( str_firesale_status == "fire_sale_on" )
				{
					level.chests[i].zbarrier clientfield::set( "magicbox_amb_sound", 1 );
					level.chests[i].zbarrier clientfield::set( "magicbox_open_fx", 1 );
				}
				else
				{
					level.chests[i].zbarrier clientfield::set( "magicbox_amb_sound", 0 );
					level.chests[i].zbarrier clientfield::set( "magicbox_open_fx", 2 );
				}
			}
		}
	}
}

function custom_magicbox_host_migration()
{
	level endon("end_game");

	level notify("mb_hostmigration");
	level endon("mb_hostmigration");

	while( 1 )
	{
		level waittill( "host_migration_end" );
		if( !isDefined( level.chests ) )
		{
			continue;
		}

		foreach( chest in level.chests )
		{
			if ( !IS_TRUE( chest.hidden ) )
			{
				if ( IsDefined( chest ) && IsDefined( chest.pandora_light ) )
				{
					PlayFXOnTag( level._effect["box_light_marker"], chest_pandora_light, "tag_origin" );
				}
			}
			util::wait_network_frame();
		}
	}
}

