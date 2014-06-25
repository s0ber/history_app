describe 'Histo', ->
  before ->
    spy(Histo.Launcher, 'initialize')

  after ->
    Histo.Launcher.initialize.restore()

  describe '.addWidget', ->
    it 'returns new widget instance', ->
      widget = Histo.addWidget id: 'my_widget'
      expect(widget.constructor).to.match /HistoryWidget/

    it 'initializes Histo when called at first time', ->
      Histo.addWidget id: 'my_widget'
      expect(Histo.Launcher.initialize).to.be.calledOnce

    it "doesn't initializes Histo when called another time", ->
      Histo.addWidget id: 'my_another_widget'
      expect(Histo.Launcher.initialize).to.be.calledOnce

