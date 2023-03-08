extends Node

class_name Events

signal on_event(event: EventBase)

func dispatch(event: EventBase):
	on_event.emit(event)
