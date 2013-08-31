money = require('common/swag').money

PriceChartView = Ember.View.extend
  content: []
  valuePadding: 10

  chartData: (->
    data = []
    @get("content").forEach (item) ->
      date = item.date
      if date
        date = new Date(date)
      else
        return unless date

      value = item.value
      return unless value

      data.push value: value, date: date
    data.sort (a, b) -> a.date - b.date
  ).property("content")

  xDomain: (->
    d3.extent @get("chartData"), (item) -> item.date
  ).property("chartData")

  yDomain: (->
    padding = @get("valuePadding")
    # d3.extent(@get("chartData"), (item) -> item.value)
    # .map (value, index) ->
    #   if index is 0
    #     Math.max (value - padding), 0
    #   else
    #     value + padding
    [0, d3.max(@get("chartData"), (item) -> item.value) + padding]
  ).property("chartData")

  updateChart: (->
    @render()
  ).observes('content')

  didInsertElement: ->
    @render()

  render: ->
    timeout = @get('renderTimeout')
    window.clearTimeout(timeout)

    renderThisAlready = => @doRender()

    @set 'renderTimeout', window.setTimeout(renderThisAlready, 50)

  doRender: (->
    data = @get("chartData")
    return unless data.length > 0

    margin =
      top: 20
      right: 20
      bottom: 50
      left: 50

    width = 420 - margin.right - margin.left
    height = 250 - margin.top - margin.top

    elementId = @get("elementId")
    x = d3.time.scale()
      .range([0, width])
      .domain @get("xDomain")

    y = d3.scale.linear()
      .rangeRound([height, 0])
      .domain @get("yDomain")

    xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .ticks(Math.floor(width/75))

    yAxis = d3.svg.axis()
      .scale(y)
      .orient("left")
      .ticks(Math.floor(height/45))
      .tickFormat money

    line = d3.svg.line()
      .interpolate("linear")
      .x (item, index) ->
        x item.date
      .y (item, index) ->
        y item.value

    container = d3.select("##{elementId}")

    # clear old charts
    container.select('svg').remove()
    $(window).off "resize", @get("onResize")

    aspect_ratio = (width + margin.left + margin.right) / (height + margin.top + margin.bottom)

    @set "onResize", =>
      $chart = $("#chart")
      targetWidth = $chart.parent().width()
      $chart.attr "width", targetWidth
      $chart.attr "height", Math.floor(targetWidth / aspect_ratio)

    $(window).on "resize", @get("onResize")

    svg = container
      .append("svg")
        .attr("id", "chart")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .attr("viewBox", "0 0 #{width + margin.left + margin.right} #{height + margin.top + margin.bottom}")
        .attr("preserveAspectRatio", "xMidYMid")

    @get("onResize")()

    chart = svg.append("g")
      .attr("transform", "translate(#{margin.left},#{margin.top})")


    chart.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,#{height})")
      .call(xAxis)

    chart.append("g")
      .attr("class", "y axis")
      .call(yAxis)

    chart.append("svg:path")
      .datum(data)
      .attr("class", "line")
      .attr("d", line)

    # add markers
    make_marker = (group, x, y, title='') ->
      group.append('svg:circle')
        .attr('class', 'data-point')
        .attr('cx', x)
        .attr('cy', y)
        .attr('r', 3)
        .attr('title', title)
        .on "mouseover", (date, index) ->
          marker = d3.select(this)
          marker.attr("r", 6)

          group.append("text")
            .attr("class", "chart-tooltip")
            .attr("transform", "translate(#{x},#{y-8})")
            .text(title);
        .on "mouseout", (date, index) ->
          d3.select(this).attr("r", 3)
          group.select("text").remove()


    markers = chart.append("svg:g").attr("class", "markers")

    data.forEach (item) ->
      make_marker markers, x(item.date), y(item.value), money(item.value)

    chart
  )

module.exports = PriceChartView