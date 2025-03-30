--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local util = require("util")
local entity = util.copy(data.raw["arithmetic-combinator"]["arithmetic-combinator"])
entity.name = "programmable-combinator"
entity.minable.result = entity.name
local item = util.copy(data.raw.item["arithmetic-combinator"])
item.name = "programmable-combinator"
item.place_result = "programmable-combinator"
local recipe = util.copy(data.raw.recipe["arithmetic-combinator"])
recipe.enabled = true
recipe.name = "programmable-combinator"
recipe.ingredients = {{type = "item", name = "wood", amount = 2}}
recipe.results = {{type = "item", name = "programmable-combinator", amount = 1}}
data:extend({item, recipe, entity})
return ____exports
