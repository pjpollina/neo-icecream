extends Control

signal dismissed

func _on_gui_input(event: InputEvent):
  if event as InputEventMouseButton:
    dismissed.emit()
