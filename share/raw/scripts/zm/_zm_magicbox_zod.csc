#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#precache( "client_fx", "zombie/fx_weapon_box_open_zod_zmb" );
#precache( "client_fx", "zombie/fx_weapon_box_closed_zod_zmb" );

#namespace zm_magicbox_zod;

function init()
{
	// custom fx
	level._effect["box_open"]		= "zombie/fx_weapon_box_open_zod_zmb";
	level._effect["box_closed"]	= "zombie/fx_weapon_box_closed_zod_zmb";

	RegisterClientField( "zbarrier", "magicbox_initial_fx", VERSION_SHIP, 1, "int", &magicbox_initial_closed_fx );
	RegisterClientField( "zbarrier", "magicbox_amb_sound", VERSION_SHIP, 1, "int", &magicbox_ambient_sound );
	RegisterClientField( "zbarrier", "magicbox_open_fx", VERSION_SHIP, 2, "int", &magicbox_open_fx );
}

function magicbox_open_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles );
	}

	if(!IsDefined(self.fx_obj_2))
	{
		self.fx_obj_2 = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles );
	}

	switch( newVal )
	{
		case 0: // BOX CLOSED
		case 3:
			if ( isDefined( self.fx_obj.curr_open_fx ) )
				StopFX( localClientNum, self.fx_obj.curr_open_fx );

			self.fx_obj.curr_amb_fx = PlayFXOnTag( localClientNum, level._effect["box_closed"], self.fx_obj, "tag_origin" );
			self.fx_obj_2 StopAllLoopSounds (1);

			self notify( "magicbox_portal_finished" );
			break;
		case 1: // BOX OPEN
			if ( isDefined( self.fx_obj.curr_amb_fx ) )
			{
				StopFX( localClientNum, self.fx_obj.curr_amb_fx );
			}

			self.fx_obj.curr_open_fx = PlayFXOnTag( localClientNum, level._effect["box_open"], self.fx_obj, "tag_origin" );
			self.fx_obj_2 PlayLoopSound ("zmb_hellbox_open_effect");
			break;
		case 2:
			self.fx_obj Delete();
			self.fx_obj_2 Delete();
			break;
	}
}

function magicbox_initial_closed_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles );
	}
	else
	{
		return; //-- early out if something else has already played an fx	
	}

	if ( newVal == 1 ) // HERE AMBIENT
	{
		self.fx_obj PlayLoopSound( "zmb_hellbox_amb_low" );
	}
}

function magicbox_ambient_sound( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if(!IsDefined(self.fx_obj))
	{
		self.fx_obj = util::spawn_model( localClientNum, "tag_origin", self.origin, self.angles );
	}

	if ( isDefined( self.fx_obj.curr_amb_fx ) )
	{
		StopFX( localClientNum, self.fx_obj.curr_amb_fx );
	}

	if ( newVal == 0 ) // NOT HERE AND POWER OFF
	{
		self.fx_obj PlayLoopSound( "zmb_hellbox_amb_low" );
		PlaySound( 0, "zmb_hellbox_leave", self.fx_obj.origin );
	}
	else if ( newVal == 1 ) // HERE AND POWER OFF
	{
		self.fx_obj PlayLoopSound( "zmb_hellbox_amb_low" );
		PlaySound( 0, "zmb_hellbox_arrive", self.fx_obj.origin );
	}
}

