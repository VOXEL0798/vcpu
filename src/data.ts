import { PrototypeData } from "factorio:common"
import * as util from "util"

declare const data: PrototypeData;
let entity = util.copy(data.raw['arithmetic-combinator']['arithmetic-combinator'])
entity.name = "programmable-combinator"
entity.minable.result = entity.name

let item = util.copy(data.raw.item['arithmetic-combinator'])
item.name = "programmable-combinator"
item.place_result = "programmable-combinator"

let recipe = util.copy(data.raw.recipe['arithmetic-combinator'])
recipe.enabled = true
recipe.name = "programmable-combinator"
recipe.ingredients = [{ type: "item", name: "wood", amount: 2 }]

recipe.results = [
    {
        type: "item",
        name: "programmable-combinator",
        amount: 1
    }
]

data.extend([item, recipe, entity])
