local status_ok, project = pcall(require, "project")
if not status_ok then
	return
end

local t_status_ok, telescope = pcall(require, "telescope")
if not t_status_ok then
	return
end

project.setup({})
telescope.load_extension("projects")
