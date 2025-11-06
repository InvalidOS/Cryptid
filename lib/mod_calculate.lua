local calc_funcs = {}

--- Adds a calculation to this mod's calculate function.
--- @param func fun(CalcContext): table? Calculation function.
--- @param priority number? Determines when this function is run. Defaults to 0.
function Cryptid.add_mod_calc(func, priority)
    -- add it
    calc_funcs[#calc_funcs+1] = { func = func, priority = to_number(priority or 0) }

    -- sort them in priority order
    if #calc_funcs >= 2 then
        table.sort(calc_funcs, function(a,b) return a.priority < b.priority end)
    end
end

-- the part that handles the mod calculates
function Cryptid.mod_obj:calculate(context)
    local effects = {}

    -- run through every calculate function, and add their returns to a table
    for _, calc in ipairs(calc_funcs) do
        local ret = calc.func(context)

        if ret then
            effects[#effects+1] = ret
        end
    end

    -- return everything
    if #effects == 1 then
        return effects[1]
    elseif #effects >= 2 then
        return SMODS.merge_effects(effects)
    end
end