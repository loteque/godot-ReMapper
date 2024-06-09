@tool
extends RefCounted
## Grumblex is a library of language extensions made by goblins.
class_name Grumblex


class Symbol:
    ## Emmited when a Symbol is updated.
    ## Emmitied with args for a 'symbol' as StringName 
    ## and a 'value' as Variant.
    signal updated(symbol: StringName, value: Variant)
    var symbol: StringName

    var value: Variant = "":
        set(new_value):
            value = new_value
            updated.emit(symbol, value)
            print("Grumblex; value set: " + value)

    func _init(string_name: StringName):
        symbol = string_name