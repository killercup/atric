PriceChartView = Ember.View.extend
  chart: {}
  line: {}
  area: {}
  content: []

  updateChart: (->
    # content = @get('content').toArray()
    # chart = @get('chart')
    # line = @get('line')
    # area = @get('area')

    # chart.selectAll('path.line')
    #   .data(content)
    #   .transition()
    #   .duration(500)
    #   .ease('sin')
    #   .attr('d', line(content))

    # chart.selectAll('path.area')
    #   .data(content)
    #   .transition()
    #   .duration(500)
    #   .ease('sin')
    #   .attr('d', area(content))

    @render()
    chart
  ).observes('content.@each.value')

  didInsertElement: ->
    @render()

  render: (->
    content = @get("content").toArray()
    return unless content.length > 0

    elementId = @get("elementId")
    margin =
      top: 35
      right: 35
      bottom: 35
      left: 35

    w = 500 - margin.right - margin.left
    h = 300 - margin.top - margin.top

    x = d3.scale.linear()
      .range([0, w])
      .domain([1, content.length-1])

    y = d3.scale.linear()
      .range([h, 0])
      .domain [0, d3.max(content.map((i) -> i.get('value')))+10]

    xAxis = d3.svg.axis()
      .scale(x)
      .ticks(10)
      .tickSize(-h)
      .tickSubdivide(true)
      # .tickFormat (d) -> d3.time.format('%x')(new Date(d))

    yAxis = d3.svg.axis()
      .scale(y)
      .ticks(4)
      .tickSize(-w)
      .orient("left")

    # Prepeare Chart Elements:
    line = d3.svg.line()
      .interpolate("linear")
      .x (d, i) ->
        x i #d3.time.format('%x') new Date(d.get("date"))
      .y (d) ->
        y d.get("value")

    @set "line", line

    area = d3.svg.area()
      .interpolate("monotone")
      .x (d) ->
        x d.get("date")
      .y0(h)
      .y1 (d) ->
        y d.get("value")

    @set "area", area

    $("#" + elementId).empty()

    chart = d3.select("#" + elementId)
      # .clear()
      .append("svg:svg")
        .attr("id", "chart")
        .attr("width", w + margin.left + margin.right)
        .attr("height", h + margin.top + margin.bottom)
      .append("svg:g")
        .attr("transform", "translate(#{margin.left},#{margin.top})")

    # Add Chart Elements to Chart:
    chart.append("svg:g")
      .attr("class", "x axis")
      .attr("transform", "translate(0,#{h})")
      .call(xAxis)

    chart.append("svg:g")
      .attr("class", "y axis")
      .call(yAxis)

    chart.append("svg:clipPath")
      .attr("id", "clip")
      .append("svg:rect")
        .attr("width", w)
        .attr("height", h)

    chart.append("svg:path")
      .attr("class", "area")
      .attr("clip-path", "url(#clip)")
      .attr("d", area(content))

    chart.append("svg:path")
      .attr("class", "line")
      .attr("clip-path", "url(#clip)")
      .attr("d", line(content))

    @set "chart", chart

    chart
  )

module.exports = PriceChartView