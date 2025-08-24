extends Node


var total_crates_to_collect := 0
var crates_on_ship := 0
var crates_remaining := 0
var ship_size := 0
var current_map := ""
var player_credits = 123456

func init_mission(ship_size_arg: int, map_id: String):
	ship_size = ship_size_arg
	current_map = map_id
	total_crates_to_collect = calculate_crates(ship_size, current_map)
	crates_remaining = total_crates_to_collect
	
func calculate_crates(size: int, map: String) -> int:
	if map:
		return 2
	else:
		return 0

func collect_crate():
	crates_remaining = total_crates_to_collect - 1
	crates_on_ship = crates_on_ship + 1

func reset_mission():
	total_crates_to_collect = 0
	crates_on_ship = 0
	crates_remaining = 0
	ship_size = 0
	current_map = ""
