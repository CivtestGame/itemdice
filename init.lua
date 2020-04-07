
-- Plays one of three sounds to player who rolled
local function play_dice_sound(soundpos)
   minetest.sound_play("itemdice_dice", {
      pos = soundpos,
      max_hear_distance = 12,
      gain = 6.0,
   })
end

-- Generate a random number between 1 and 6 and sends it to the roller
minetest.register_craftitem("itemdice:d6", {
    description = "Six Sided Die",
    inventory_image = "itemdice_dice.png",
    on_use = function(itemstack, player, pointed_thing)
       -- Starts sound
       play_dice_sound(player:get_pos())
       --Sends the result, a context message to player who rolled
       minetest.chat_send_player(
          player:get_player_name(), "You rolled a " .. math.random(1, 6) .. "!"
       )
    end
})

-- A simple crafting recipe requiring only paper and a wood
minetest.register_craft({
    output = "itemdice:d6",
    recipe = {
       { "default:paper", "group:wood" }
    },
})

--A simple crafting recipe requiring only two paper, wood and a coal lump put on the crafting table in any position
minetest.register_craft({
    type = "shaped",
    output = "itemdice:big_d6_1",
    recipe = {
       { "default:paper", "dye:black" },
       { "group:wood",    "group:wood" },
    },
})

-- Makes six copies of a node with the difference between being the texture and
-- node name
for i = 6,1,-1 do
   minetest.register_node("itemdice:big_d6_" .. i,{
      description = "Large Six Sided Die",
      -- itemdice:big_d6_2 has the number two as the texture etc
      tiles = {"itemdice_" .. i .. ".png"},
      is_ground_content = true,
      groups = {choppy = 2},
      on_rightclick = function(pos, node, player, itemstack, pointed_thing)
         play_dice_sound(player:get_pos())
         -- Randomly chooses between the six nodes, result being the texture
         minetest.set_node(
            pos, { name = "itemdice:big_d6_" .. math.random(1,6) }
         )
      end
   })
end
