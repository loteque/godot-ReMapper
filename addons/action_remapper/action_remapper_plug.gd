@tool
extends EditorPlugin

var docked_scene

func _enter_tree():
    add_custom_type("ReMapperButton", "Button", preload("user/ReMapperButton.gd"), preload("icon.png"))

func _exit_tree():
    remove_control_from_docks(docked_scene)
    docked_scene.free()
