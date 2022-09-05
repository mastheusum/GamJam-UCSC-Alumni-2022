extends Spatial

export var navMesh : NavigationMesh

var region_rid : RID

onready var map_rid = get_viewport().get_world().get_navigation_map()

func _ready():
	region_rid = NavigationServer.region_create()
	NavigationServer.map_set_cell_size( map_rid, 0.25 )
	NavigationServer.region_set_navmesh( region_rid, navMesh )
	NavigationServer.region_set_map( region_rid, map_rid )
	NavigationServer.map_set_active( region_rid, true )
