import jsonschema
from jsonschema import validate
import os
from jsonschema import Draft7Validator
import json

path_schema = './'

schemafiles = []
for r, d, f in os.walk(path_schema):
    for file in f:
        if file.endswith('.json'):
            schemafiles.append(path_schema+"/"+file)

for schemafile in schemafiles:
    with open(schemafile) as g:
        try:
            print(schemafile + "    ", end="")
            with open("structure.json") as data:
                data = json.loads(data.read())
                res = validate(data, json.loads(g.read()))
                print("Успех")
        except jsonschema.exceptions.ValidationError as ve:
            print("Ошибка:")
            print(type(ve))
            print(ve)
    print()


