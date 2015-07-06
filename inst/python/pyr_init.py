import json
import collections
import pyr
def _pyr_str_to_args(json_string):
    obj = json.JSONDecoder(object_pairs_hook=collections.OrderedDict).decode(json_string)
    if isinstance(obj, dict):
        args = [v for i, (k, v) in enumerate(obj.items()) if k == str(i+1)]
    elif isinstance(obj, list):
        args = obj
    else:
        args = []
    args = [v if len(v) > 1 else (None if len(v) == 0 else v[0]) for v in args]
    return args

def _pyr_str_to_kwargs(json_string):
    obj = json.JSONDecoder(object_pairs_hook=collections.OrderedDict).decode(json_string)
    if isinstance(obj, dict):
        kwargs = [(k, v) for i, (k, v) in enumerate(obj.items()) if k != str(i+1)]
    else:
        kwargs = []
    kwargs = dict([(k, v if len(v) > 1 else (None if len(v) == 0 else v[0])) for k, v in kwargs])
    return kwargs

def _pyr_str_to_obj(json_string):
    obj = json.JSONDecoder(object_pairs_hook=collections.OrderedDict).decode(json_string)
    if isinstance(obj, (list, dict)) and len(obj) == 0:
        return None
    if isinstance(obj, list):
        if len(obj) == 1:
            return obj[0]
    return obj

pyr.str_to_args = _pyr_str_to_args
pyr.str_to_kwargs = _pyr_str_to_kwargs
pyr.str_to_obj = _pyr_str_to_obj
