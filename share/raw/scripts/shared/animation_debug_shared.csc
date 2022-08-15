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
		
	while ( true )
	{
		level flagsys::wait_till( "anim_debug" );
		
		_init_frame();
		
		str_extra_info = "";
		color = CYAN;
		
		if ( flagsys::get( "firstframe" ) )
		{
			str_extra_info += "(first frame)";
		}
	
		/*//TODO T7 - port function if needed
		if ( !IsAssetLoaded( "xanim", STR( animation ) ) )
		{
			str_extra_info += "(missing)";
			color = RED;
		}
		*/
		
		s_pos = _get_align_pos( v_origin_or_ent, v_angles_or_tag );
		self anim_origin_render( s_pos.origin, s_pos.angles );
		
		Line( self.origin, s_pos.origin, color, .5, true );
		Sphere( s_pos.origin, 2, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), .5, true );
		
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
			
			Print3d( v_origin_or_ent.origin + ( 0, 0, 5 ), str_name, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), 1, ANIM_DEBUG_TEXT_SMALL );
		}

		self anim_origin_render( self.origin, self.angles );
		
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
		
		Print3d( self.origin, self GetEntNum() + get_ent_type() + ":name:" + str_name, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SCALE );
		Print3d( self.origin - ( 0, 0, 5 ), "animation:" + animation, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SCALE );
		Print3d( self.origin - ( 0, 0, 7 ), str_extra_info, color, ANIM_DEBUG_TEXT_ALPHA, ANIM_DEBUG_TEXT_SMALL );

		render_tag( "tag_weapon_right", "right" );
		render_tag( "tag_weapon_left", "left" );
		render_tag( "tag_player", "player" );
		render_tag( "tag_camera", "camera" );
		
		_reset_frame();
		
		wait .01;
	}
}

function get_ent_type()
{
	/*if ( IsAI( self ) )
	{
		return "{ai}";
	}
	else if ( IsVehicle(self) )
	{
		return "{vehicle}";
	}
	else
	{*/
		return "{" + ( isdefined( self.classname ) ? self.classname : "" ) + "}";
	/*}*/
}

function _init_frame()
{
//	self.v_centroid = self GetCentroid();
}

function _reset_frame()
{
	self.v_centroid = undefined;
}

function render_tag( str_tag, str_label )
{
	DEFAULT( str_label, str_tag );
//	DEFAULT( self.v_centroid, self GetCentroid() );
	
	v_tag_org = self GetTagOrigin( str_tag );
	if ( isdefined( v_tag_org ) )
	{
		v_tag_ang = self GetTagAngles( str_tag );
		anim_origin_render( v_tag_org, v_tag_ang, 2, str_label );
		
		if ( isdefined( self.v_centroid ) )
		{
			Line( self.v_centroid, v_tag_org, ( ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE, ANIM_DEBUG_TEXT_SCALE ), .5, true );
		}
	}
}

function anim_origin_render( org, angles, line_length = 6, str_label )
{
	if ( isdefined( org ) && isdefined( angles ) )
	{
		originEndPoint = org + VectorScale( AnglesToForward( angles ), line_length );
		originRightPoint = org + VectorScale( AnglesToRight( angles ), -1 * line_length );
		originUpPoint = org + VectorScale( AnglesToUp( angles ), line_length );
		
		Line( org, originEndPoint, RED );
		Line( org, originRightPoint, GREEN );
		Line( org, originUpPoint, BLUE );
		
		if ( isdefined( str_label ) )
		{
			Print3d( org, str_label, RGB( 255, 192, 203 ), 1, .05 );
		}
	}
}

#/
