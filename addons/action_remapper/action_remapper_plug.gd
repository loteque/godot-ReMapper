@tool
extends EditorPlugin

const panel: PackedScene = preload("action_remapper_panel.tscn")

var docked_scene

func _enter_tree():
    docked_scene = panel.instantiate()
    add_control_to_dock(DOCK_SLOT_LEFT_UR, docked_scene)

func _exit_tree():
    remove_control_from_docks(docked_scene)
    docked_scene.free()
