money = require('common/swag').money

PriceChartView = Ember.View.extend
  chart: {}
  line: {}
  area: {}
  content: []

  updateChart: (->
    @render()
  ).observes('content.@each.value')

  didInsertElement: ->
    @render()

  render: (->
    window.chartData = data = []
    @get("content").forEach (item) ->
      date = item.get('date')
      if date
        date = new Date(date)
      else
        return unless date

      value = item.get('value')
      return unless value

      data.push value: value, date: date

    return unless data.length > 0

    margin =
      top: 10
      right: 10
      bottom: 50
      left: 50

    width = 420 - margin.right - margin.left
    height = 250 - margin.top - margin.top

    elementId = @get("elementId")
    x = d3.time.scale()
      .range([0, width])
      .domain d3.extent data, (item) -> new Date(item.date)

    y = d3.scale.linear()
      .rangeRound([height, 0])
      .domain do ->
        d3.extent(data, (item) -> item.value)
        .map (value, index) ->
          if index is 0
            Math.max (value - 10), 0
          else
            value + 10

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
        x new Date(item.date)
      .y (item, index) ->
        y item.value


    container = d3.select("##{elementId}")

    container.select('svg').remove()

    chart = container
      .append("svg:svg")
        .attr("id", "chart")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
      .append("g")
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
      make_marker markers, x(new Date(item.date)), y(item.value), money(item.value)

    chart
  )

module.exports = PriceChartView