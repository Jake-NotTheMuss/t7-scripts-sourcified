#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#insert scripts\shared\shared.gsh;

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_metro_fx;
#using scripts\mp\mp_metro_sound;

#insert scripts\shared\version.gsh;

#precache( "client_fx", "ui/fx_dom_cap_indicator_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_cap_indicator_team_r120" );
#precache( "client_fx", "ui/fx_dom_marker_neutral_r120" );
#precache( "client_fx", "ui/fx_dom_marker_team_r120" );

function main()
{
	mp_metro_fx::main();
	mp_metro_sound::main();
	
	clientfield::register( "scriptmover", "mp_metro_train_timer", VERSION_SHIP, 1, "int", &trainTimerSpawned, CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
		
	load::main();

	level.domFlagBaseFxOverride = &dom_flag_base_fx_override;
	level.domFlagCapFxOverride = &dom_flag_cap_fx_override;

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.

	level.endGameXCamName = "ui_cam_endgame_mp_metro";

	SetDvar( "phys_buoyancy", true );
	SetDvar( "phys_ragdoll_buoyancy", true );
}

function train_countdown( localClientNum )
{
	self endon( "entityshutdown" );
	angles = ( self.angles[0], -self.angles[1], 0 );

	
	minutesOrigin = self.origin + ( cos(self.angles[1] ) * 37, sin( self.angles[1] ) * 37, 0 );
	numberModelMinutes = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", minutesOrigin, angles );
	
	colonOrigin = self.origin + ( cos(self.angles[1]) * 37 * 2, sin( self.angles[1] ) * 37 * 2, 0 );
	numberModelcolon = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", colonOrigin, angles );
	
	tensOrigin = self.origin - ( cos(self.angles[1]) * 37, sin( self.angles[1] ) * 37, 0 );
	numberModelTens = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", tensOrigin, angles );
	
	onesOrigin = self.origin - ( cos(self.angles[1]) * 37 * 2, sin( self.angles[1] ) * 37 * 2, 0 );
	numberModelOnes = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", onesOrigin, angles );

	currentNumber = 1;

	currentNumberLarge = 0;
	for ( ;; )
	{		
		currentNumber++;
		if ( currentNumber > 9 )
		{
			currentNumber = 0;
		}
			
		displayNumber = int( ceil( ( self.angles[2]) ) );
		if ( displayNumber < 0 )
		{
			displayNumber += 360;
		}
		
		if ( displayNumber < 0 || displayNumber > 360 )
		{
			displayNumber = 0;
		}
		
		numberModelOnes setModel( "p7_3d_txt_antiqua_bold_0" + ( displayNumber % 10 ) + "_brushed_aluminum");
		
		numberModelTens setModel( "p7_3d_txt_antiqua_bold_0" + ( int( ( displayNumber % 60 ) / 10  ) ) + "_brushed_aluminum");
		
		numberModelMinutes setModel( "p7_3d_txt_antiqua_bold_0" + ( int( displayNumber / 60 ) ) + "_brushed_aluminum");
		
		wait( 0.05 );
	}
}

function trainTimerSpawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump )
{
	if ( !newVal )
		return;

	if ( newVal == 1 )
	{
		self thread train_countdown( localClientNum );
	}
}

function dom_flag_base_fx_override( flag, team )
{
	switch ( flag.name )
	{
		case "a":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		case "b":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
		case "c":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_marker_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_marker_team_r120";
			}
			break;
	};
}

function dom_flag_cap_fx_override( flag, team )
{
	switch ( flag.name )
	{
		case "a":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		case "b":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
		case "c":
			if ( team == "neutral" )
			{
				return "ui/fx_dom_cap_indicator_neutral_r120";
			}
			else
			{
				return "ui/fx_dom_cap_indicator_team_r120";
			}
			break;
	};
}
