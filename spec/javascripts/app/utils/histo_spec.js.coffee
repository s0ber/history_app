describe 'Histo', ->
  originalHistory = Histo._history()

  before ->
    spy(Histo.Launcher, 'initialize')

  after ->
    Histo.Launcher.initialize.restore()
    Histo._history = ->
      originalHistory

  beforeEach ->
    Histo.widgets = {}
    Histo._currentState = null

  afterEach ->
    Histo.widgets = {}

  describe '.addWidget', ->
    it 'returns new widget instance', ->
      widget = Histo.addWidget id: 'my_widget'
      expect(widget.constructor).to.match /Widget/

    it 'initializes Histo when called at first time', ->
      Histo.addWidget id: 'my_widget'
      expect(Histo.Launcher.initialize).to.be.calledOnce

    it "doesn't initializes Histo when called another time", ->
      Histo.addWidget id: 'my_another_widget'
      expect(Histo.Launcher.initialize).to.be.calledOnce

    it 'saves reference to created widget in @_widgets', ->
      widget = Histo.addWidget id: 'my_widget'
      expect(Histo.widgets['my_widget']).to.be.equal widget

  describe '.saveCurrentState', ->
    it 'clones provided "state" object in @_currentState', ->
      currentState = value: 1
      Histo.saveCurrentState(currentState)
      expect(Histo._currentState).to.be.eql currentState
      expect(Histo._currentState).to.not.be.equal currentState

  describe '.supplementState', ->
    beforeEach ->
      fakeHistoryApi = new FakeHistoryApi()
      Histo._history = -> fakeHistoryApi

      @widget = Histo.addWidget id: 'my_widget'
      @anotherWidget = Histo.addWidget id: 'my_another_widget'

      @widgetState1 = value: 1
      @widgetState2 = value: 2
      @anotherWidgetState1 = property: 1
      @anotherWidgetState2 = property: 2

    context 'there is no current history state', ->
      it 'saves provided widget state with state_id equal to 0', ->
        @widget.replaceInitialState(@widgetState1)
        expectedWidgetState = _.extend({}, @widgetState1, state_id: 0)
        expect(Histo._history().state['my_widget']).to.be.eql expectedWidgetState

    context 'there is current history state', ->
      it 'adds provided widget state to global state with state_id equal to 0', ->
        @widget.replaceInitialState(@widgetState1)
        @anotherWidget.replaceInitialState(@anotherWidgetState1)

        expectedWidgetState = _.extend({}, @widgetState1, state_id: 0)
        expectedAnotherWidgetState = _.extend({}, @anotherWidgetState1, state_id: 0)

        expect(Histo._history().state['my_widget']).to.be.eql expectedWidgetState
        expect(Histo._history().state['my_another_widget']).to.be.eql expectedAnotherWidgetState

    context 'there is current history state for provided widget', ->
      it "replaces widget state, but doesn't change it's state_id", ->
        @widget.replaceInitialState(@widgetState1)
        @widget.replaceInitialState(@widgetState2)

        expectedWidgetState = _.extend({}, @widgetState2, state_id: 0)
        expect(Histo._history().state['my_widget']).to.be.eql expectedWidgetState

    it 'saves new state in @currentState', ->
      @widget.replaceInitialState(@widgetState1)
      @widget.replaceInitialState(@widgetState2)

      expect(Histo._currentState).to.be.eql
        'my_widget':
          state_id: 0
          value: 2

