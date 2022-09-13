local function alert(body)
	require("notify")(body, "info", {
		title = "Buffer Api Demo",
	})
end

alert("Hello wolrd")
