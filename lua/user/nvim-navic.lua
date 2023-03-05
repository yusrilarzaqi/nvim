-- Customized config
local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
	return
end

navic.setup({
	icons = {
		File = " ",
		Module = " ",
		Namespace = " ",
		Package = " ",
		Class = " ",
		Method = " ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = " ",
		Interface = " ",
		Function = " ",
		Variable = " ",
		Constant = " ",
		String = " ",
		Number = " ",
		Boolean = " ",
		Array = " ",
		Object = " ",
		Key = " ",
		Null = " ",
		EnumMember = " ",
		Struct = " ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
	},
	--[[ icons = {
		File = " ",
		Module = " ",
		Namespace = " ",
		Package = " ",
		Class = " ",
		Method = " ",
		Property = " ",
		Field = " ",
		Constructor = " ",
		Enum = "練",
		Interface = "練",
		Function = " ",
		Variable = " ",
		Constant = " ",
		String = " ",
		Number = " ",
		Boolean = "◩ ",
		Array = " ",
		Object = " ",
		Key = " ",
		Null = "ﳠ ",
		EnumMember = " ",
		Struct = " ",
		Event = " ",
		Operator = " ",
		TypeParameter = " ",
	}, ]]

	highlight = true,
	separator = " : ",
	depth_limit = 0,
	--[[ depth_limit_indicator = "..", ]]
})


--[[ `NavicIconsFile`
	`NavicIconsModule`
	`NavicIconsNamespace`
	`NavicIconsPackage`
	`NavicIconsClass`
	`NavicIconsMethod`
	`NavicIconsProperty`
	`NavicIconsField`
	`NavicIconsConstructor`
	`NavicIconsEnum`
	`NavicIconsInterface`
	`NavicIconsFunction`
	`NavicIconsVariable`
	`NavicIconsConstant`
	`NavicIconsString`
	`NavicIconsNumber`
	`NavicIconsBoolean`
	`NavicIconsArray`
	`NavicIconsObject`
	`NavicIconsKey`
	`NavicIconsNull`
	`NavicIconsEnumMember`
	`NavicIconsStruct`
	`NavicIconsEvent`
	`NavicIconsOperator`
	`NavicIconsTypeParameter`
	`NavicText`
	`NavicSeparator` ]]
