{CompositeDisposable} = require "atom"
util = require "./util"

module.exports = ProjectPlus =
  projectPlusView: null
  modalPanel: null
  subscriptions: null

  config:
    showPath:
      type: 'boolean'
      default: true
      title: 'Show Project Path'
      description: 'Show project folder paths under the name of each project in the project finder.'

    projectHome:
      type: 'string'
      default: ''
      title: 'Project Home'
      description: 'The directory where projects are assumed to be located. Projects outside of this directory will never be shown in the project finder.'

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up
    # with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add "atom-workspace",
      "project-plus:open": =>
        atom.pickFolder (selectedPaths = []) =>
          if selectedPaths
            util.switchToProject({paths: selectedPaths})

      "project-plus:close": =>
        util.closeProject()

      "project-plus:toggle-project-finder": =>
        @getProjectFinder().toggle()

      "project-plus:open-next-recently-used-project": =>
        @getProjectTab().next()

      "project-plus:open-previous-recently-used-project": =>
        @getProjectTab().previous()

      "project-plus:move-active-project-to-top-of-stack": =>
        # Clear the tab index
        @projectTab = null

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @projectPlusView.destroy()

  serialize: ->

  getProjectFinder: ->
    unless @projectFinderView?
      ProjectFinderView = require "./project-finder-view"
      @projectFinderView = new ProjectFinderView()

    @projectFinderView

  getProjectTab: ->
    unless @projectTab
      ProjectTab = require "./project-tab"
      @projectTab = new ProjectTab()

    @projectTab
