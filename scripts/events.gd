extends Node

signal on_event(event: EventBase)

func dispatch(event: EventBase):
	on_event.emit(event)
