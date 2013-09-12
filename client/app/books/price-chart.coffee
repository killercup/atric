money = require('common/swag').money

PriceChartView = Ember.View.extend
  classNames: ['price-chart', 'chart']

  content: []

  valuePadding: 10
  width: 420
  height: 250

  chartData: (->
    content = @get("content")
    return unless content?

    data = []
    content.forEach (item, index) ->
      date = item.date
      return unless date

      if !(date.getTimezoneOffset and date.setUTCFullYear)
        date = new Date(date)

      value = item.value
      return unless value

      # Skip values that do lay perfectly on the line between the
      # previous and next element. This way, there are less markers.
      prev = content[index-1] || {}
      next = content[index+1] || {}
      if (prev.date) and (prev.value is value) and (next.value is value) and (next.date)
        return

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
    return unless data?.length > 0

    margin =
      top: 20
      right: 20
      bottom: 50
      left: 50

    width = @get('width') - margin.right - margin.left
    height = @get('height') - margin.top - margin.top

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
        # .on "mouseover", (date, index) ->
          # marker = d3.select(this)
          # marker.attr("r", 6)

          # group.append("text")
          #   .attr("class", "chart-tooltip")
          #   .attr("transform", "translate(#{x},#{y-8})")
          #   .text(title)
        # .on "mouseout", (date, index) ->
          # d3.select(this).attr("r", 3)
          # group.select("text").remove()

    markers = chart.append("svg:g").attr("class", "markers")

    format_date = d3.time.format('%d %b %y %H:%M:%S')

    data.forEach (item) ->
      make_marker markers, x(item.date), y(item.value), "#{money(item.value)}\n #{format_date item.date}"

    circles = markers.selectAll('circle')
    circles.on 'mouseover', ((item, index) ->
      $this = $(this)
      $chart = $("##{elementId}")

      # make dot bigger
      $this.attr r: 6

      [value, date] = $this.attr('title').split('\n')

      $tooltip = $ """<div class="popover bottom">
        <div class="arrow"></div>
        <h3 class="popover-title">#{value}</h3>
        <div class="popover-content">
          #{date}
        </div>
      </div>"""

      chartOffset = $chart.offset()
      circleOffset = $this.offset()

      # position tooltip just below the marker circle
      $tooltip.css
        top: 12 + circleOffset.top - chartOffset.top
        left: circleOffset.left - chartOffset.left

      $this.data 'tooltip', $tooltip

      $chart.append $tooltip
      return
    )
    circles.on 'mouseout', ((item, index) ->
      $this = $(this)

      # shrink dot back to original size
      $this.attr r: 3

      # remove le tooltip
      $this.data('tooltip').remove()
      return
    )

    chart
  )

module.exports = PriceChartView