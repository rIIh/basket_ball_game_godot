extends GameEffect

class_name GameModifier

# chain method defines multiple modifiers total effect
# by default: result of chain is last modifier of first modifier type
# 
# passed modifier should be same type 
func chain(modifier: GameModifier) -> GameModifier:
	return self if check_chainable(modifier) else modifier

func check_chainable(with_modifier: GameModifier) -> bool:
	return false
