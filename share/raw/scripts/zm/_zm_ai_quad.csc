#using scripts\codescripts\struct;

#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace zm_ai_quad;

REGISTER_SYSTEM( "zm_ai_quad", &__init__, undefined )

function __init__()
{
	visionset_mgr::register_overlay_info_style_blur( "zm_ai_quad_blur", VERSION_DLC5, 1, 0.1, 0.5, 4 );
}

