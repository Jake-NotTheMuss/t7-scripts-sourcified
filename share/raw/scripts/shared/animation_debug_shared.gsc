#using scripts\shared\animation_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

#insert scripts\shared\shared.gsh;

#namespace animation;

#define ANIM_DEBUG_TEXT_SCALE .3
#define ANIM_DEBUG_TEXT_SMALL .15
#define ANIM_DEBUG_TEXT_ALPHA .8

/#

function autoexec __init__()
{
	SetDvar( "anim_debug", 0 );
	SetDvar( "anim_debug_pause", 0 );
	
	while ( true )
	{
		anim_debug = GetDvarInt( "anim_debug", 0 ) || GetDvarInt( "anim_debug_pause", 0 );
		level flagsys::set_val( "anim_debug", anim_debug );
		if ( !anim_debug )
		{
			level notify( "kill_anim_debug" );
		}
		wait .05;
	}
}

function anim_info_render_thread( animation, v_origin_or_ent, v_angles_or_tag, n_rate, n_blend_in, n_blend_out, n_lerp )
{
	self endon( "death" );
	self endon( "scriptedanim" );
	
	self notify( "_anim_info_render_thread_" );
	self endon( "_anim_info_render_thread_" );
	
	if ( !IsVec( v_origin_or_ent ) )
	{
		v_origin_or_ent endon( "death" );
	}
	
	RecordEnt( self );
		
	while ( true )
	{
		level flagsys::wait_till( "anim_debug" );
		
		b_anim_debug_on = true;
		
		_init_frame();
		
		str_extra_info = "";
		color = YELLOW;
		
		if ( flagsys::get( "firstframe" ) )
		{
			str_extra_info += "(first frame)";
		}
		
		s_pos = _get_align_pos( v_origin_or_ent, v_angles_or_tag );
		self anim_origin_render( s_pos.origin, s_pos.angles, undefined, undefined, !b_anim_debug_on );
		
		if ( b_anim_debug_on )
		{
			Line( self.origin, s_pos.origin, color, .5, true );
			Sphere( s_pos.origin, 2, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), .5, true );
		}
		
		RecordLine( self.origin, s_pos.origin, color, "ScriptedAnim" );		
		RecordSphere( s_pos.origin, 2, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), "ScriptedAnim" );
		
		if ( !IsVec( v_origin_or_ent ) && ( v_origin_or_ent != self && v_origin_or_ent != level ) )
		{
			str_name = "no name";
			if ( isdefined( v_origin_or_ent.animname ) )
			{
				str_name = v_origin_or_ent.animname;
			}
			else if ( isdefined( v_origin_or_ent.targetname ) )
			{
				str_name = v_origin_or_ent.targetname;
			}
			
			if ( b_anim_debug_on )
			{
				Print3d( v_origin_or_ent.origin + ( 0, 0, 5 ), str_name, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), 1, ANIM_DEBUG_TEXT_SMALL );
			}
			
			Record3DText( str_name, v_origin_or_ent.origin + ( 0, 0, 5 ), ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), "ScriptedAnim" );
		}

		self anim_origin_render( self.origin, self.angles, undefined, undefined, !b_anim_debug_on );
		
		str_name = "no name";
		if ( isdefined( self.anim_debug_name ) )
		{
			str_name = self.anim_debug_name;
		}
		else if ( isdefined( self.animname ) )
		{
			str_name = self.animname;
		}
		else if ( isdefined( self.targetname ) )
		{
			str_name = self.targetname;
		}
		
		if ( b_anim_debug_on )
		{
			Print3d( self.origin, self GetEntNum() + get_ent_type() + ":name:" + str_name, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SCALE );
			Print3d( self.origin - ( 0, 0, 5 ), "animation:" + animation, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SCALE );
			Print3d( self.origin - ( 0, 0, 7 ), str_extra_info, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SMALL );
		}
		
		Record3DText( self GetEntNum() + get_ent_type() + ":name:" + str_name, self.origin, color, "ScriptedAnim" );
		Record3DText( "animation:" + animation, self.origin - ( 0, 0, 5 ), color, "ScriptedAnim" );
		Record3DText( str_extra_info, self.origin - ( 0, 0, 7 ), color, "ScriptedAnim" );

		render_tag( "tag_weapon_right", "right", !b_anim_debug_on );
		render_tag( "tag_weapon_left", "left", !b_anim_debug_on );
		render_tag( "tag_player", "player", !b_anim_debug_on );
		render_tag( "tag_camera", "camera", !b_anim_debug_on );
		
		_reset_frame();
		
		WAIT_SERVER_FRAME;
	}
}

function get_ent_type()
{
	if ( IsActor( self ) )
	{
		return "{ai}";
	}
	else if ( IsVehicle( self ) )
	{
		return "{vehicle}";
	}
	else
	{
		return "{" + self.classname + "}";
	}
}

function _init_frame()
{
	self.v_centroid = self GetCentroid();
}

function _reset_frame()
{
	self.v_centroid = undefined;
}

function render_tag( str_tag, str_label, b_recorder_only )
{
	DEFAULT( str_label, str_tag );
	DEFAULT( self.v_centroid, self GetCentroid() );
	
	v_tag_org = self GetTagOrigin( str_tag );
	if ( isdefined( v_tag_org ) )
	{
		v_tag_ang = self GetTagAngles( str_tag );
		anim_origin_render( v_tag_org, v_tag_ang, 2, str_label, b_recorder_only );
		
		if ( !b_recorder_only )
		{
			Line( self.v_centroid, v_tag_org, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), .5, true );
		}
		
		RecordLine( self.v_centroid, v_tag_org, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), "ScriptedAnim" );
	}
}

function anim_origin_render( org, angles, line_length = 6, str_label, b_recorder_only )
{
	if ( isdefined( org ) && isdefined( angles ) )
	{
		originEndPoint = org + VectorScale( AnglesToForward( angles ), line_length );
		originRightPoint = org + VectorScale( AnglesToRight( angles ), -1 * line_length );
		originUpPoint = org + VectorScale( AnglesToUp( angles ), line_length );
		
		if ( !b_recorder_only )
		{		
			Line( org, originEndPoint, RED );
			Line( org, originRightPoint, GREEN );
			Line( org, originUpPoint, BLUE );
		}
		
		RecordLine( org, originEndPoint, RED, "ScriptedAnim" );
		RecordLine( org, originRightPoint, GREEN, "ScriptedAnim" );
		RecordLine( org, originUpPoint, BLUE, "ScriptedAnim" );
		
		if ( isdefined( str_label ) )
		{
			if ( !b_recorder_only )
			{
				Print3d( org, str_label, RGB( 255, 192, 203 ), 1, .05 );
			}
			
			Record3DText( str_label, org, RGB( 255, 192, 203 ), "ScriptedAnim" );
		}
	}
}

#/
