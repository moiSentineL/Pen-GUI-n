function initUi()
	app.registerUi({
		["menu"] = "Pen tool",
		["callback"] = "pen",
		["accelerator"] = "p",
	})
	app.registerUi({
		["menu"] = "Eraser tool",
		["callback"] = "eraser",
		["accelerator"] = "e",
	})
	app.registerUi({
		["menu"] = "Text tool",
		["callback"] = "text",
		["accelerator"] = "t",
	})
	app.registerUi({
		["menu"] = "Rectangular Select tool",
		["callback"] = "rect_sel",
		["accelerator"] = "r",
	})
	app.registerUi({
		["menu"] = '"Squiggly" Select tool',
		["callback"] = "squig_sel",
		["accelerator"] = "s",
	})
	app.registerUi({
		["menu"] = "Highlighter tool",
		["callback"] = "highlighter",
		["accelerator"] = "v",
	})
	app.registerUi({
		["menu"] = "LaTex tool",
		["callback"] = "latex",
		["accelerator"] = "x",
	})
	app.registerUi({
		["menu"] = "Toggle dashed pen",
		["callback"] = "pen_dashed",
		["accelerator"] = "d",
	})
	app.registerUi({
		["menu"] = "Toggle line tool",
		["callback"] = "line",
		["accelerator"] = "l",
	})
	app.registerUi({
		["menu"] = "Toggle arrow tool",
		["callback"] = "toggle_arrow",
		["accelerator"] = "a",
	})
	app.registerUi({
		["menu"] = "Toggle coordinate system",
		["callback"] = "coord",
		["accelerator"] = "c",
	})
end

function pen()
	app.uiAction({ ["action"] = "ACTION_TOOL_PEN" })
	app.uiAction({ ["action"] = "ACTION_TOOL_LINE_STYLE_PLAIN" })
end

function eraser()
	app.uiAction({ ["action"] = "ACTION_TOOL_ERASER" })
end

function text()
	app.uiAction({ ["action"] = "ACTION_TOOL_TEXT" })
end

function rect_sel()
	app.uiAction({ ["action"] = "ACTION_TOOL_SELECT_RECT" })
end

function squig_sel()
	app.uiAction({ ["action"] = "ACTION_TOOL_SELECT_REGION" })
end

function highlighter()
	app.uiAction({ ["action"] = "ACTION_TOOL_HIGHLIGHTER" })
end

function latex()
	app.uiAction({ ["action"] = "ACTION_TEX" })
end

function line()
	app.uiAction({ ["action"] = "ACTION_TOOL_PEN" })
	app.uiAction({ ["action"] = "ACTION_RULER" })
end

function arrow()
	app.uiAction({ ["action"] = "ACTION_TOOL_PEN" })
	app.uiAction({ ["action"] = "ACTION_TOOL_DRAW_ARROW" })
end

function coord()
	app.uiAction({ ["action"] = "ACTION_TOOL_PEN" })
	app.uiAction({ ["action"] = "ACTION_TOOL_DRAW_COORDINATE_SYSTEM" })
end

local dashed = false
function pen_dashed()
	if dashed then
		pen()
	else
		app.uiAction({ ["action"] = "ACTION_TOOL_PEN" })
		app.uiAction({ ["action"] = "ACTION_TOOL_LINE_STYLE_DASH" })
	end
	dashed = not dashed
end

function create_modifier_toggler(base_tool_action, modifier_action)
	-- This private state is local to this specific toggle function instance
	local is_modifier_active = false

	-- The returned function is what you bind to your custom shortcut
	return function()
		-- 1. ALWAYS select the base tool first to ensure context
		app.uiAction({ ["action"] = base_tool_action })

		-- 2. Toggle the modifier itself.
		-- Since the modifier is in the BOOLEAN_ACTION_MAP, calling it once
		-- should turn it ON, and calling it again should turn it OFF.
		app.uiAction({ ["action"] = modifier_action })

		-- 3. Update the Lua-side state (optional, for display/logging,
		-- but good practice for internal logic)
		is_modifier_active = not is_modifier_active

		print(string.format("Toggled %s. Current state: %s", modifier_action, is_modifier_active and "ON" or "OFF"))
	end
end

local PEN_TOOL = "ACTION_TOOL_PEN"

-- 1. Arrow Toggler
function toggle_arrow()
	-- Create and assign the specific toggler function instance
	-- We assume the arrow drawing mode applies to the Pen tool
	toggle_arrow = create_modifier_toggler(PEN_TOOL, "ACTION_TOOL_DRAW_ARROW")

	-- Run it the first time (since we overwrote the function definition)
	toggle_arrow()
end
