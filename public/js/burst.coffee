Template.starburstAL.rendered = () ->
  data = @data.answers
  #console.log data
  if data
    rick = new Starburst()
    rick.data(data)

class Starburst
  uuid: uuid.v4()

  constructor: (@height, @width) ->
    @height = 500 unless @height
    @width = 410 unless @width

    @radius = Math.min(@width, @height) / 2

    @x = d3.scale.linear().range([0, 2 * Math.PI])
    @y = d3.scale.sqrt().range([0, @radius])

    @color = d3.scale.category20c()

    @svg = d3.select("#starburst").append("svg")
      .attr("width", @width)
      .attr("height", @height)
      .append("g")
      .attr("transform", "translate(" + @width / 2 + "," + (@height / 2 + 10) + ")")

      .on "mousemove", (d) => 
        Session.set 'curInfoStyle' 
        # return @tooltip.style("top", (event.pageY-10)+"px").style("left",(event.pageX+10)+"px")
      .on "mouseout", (d) => 
        return @tooltip.style("visibility", "hidden")


    @partition = d3.layout.partition()
      .sort(null)
      # .value (d) -> 
      #   return 1

    @arc = d3.svg.arc()
      .startAngle (d) => 
        return Math.max(0, Math.min(2 * Math.PI, @x(d.x))) 
      .endAngle (d) => 
        return Math.max(0, Math.min(2 * Math.PI, @x(d.x + d.dx)))
      .innerRadius (d) => 
        return Math.max(0, @y(d.y))
      .outerRadius (d) => 
        return Math.max(0, @y(d.y + d.dy))

    # Keep track of the node that is currently being displayed as the root.
    @node = null

  #d3.select(self.frameElement).style("height", @height + "px")

  data: (root) =>
    root = window.bob unless root
    @node = root

    # Setup for switching data: stash the old values for transition.
    stash = (d) ->
      d.x0 = d.x
      d.dx0 = d.dx
    
    # When switching data: interpolate the arcs in data space.
    arcTweenData = (a, i) =>
      oi = d3.interpolate({x: a.x0, dx: a.dx0}, a)

      tween = (t) =>
        b = oi(t)
        a.x0 = b.x
        a.dx0 = b.dx
        return @arc(b)
      
      if (i is 0)
        # If we are on the first arc, adjust the x domain to match the root node
        # at the current zoom level. (We only need to do this once.)
        xd = d3.interpolate(@x.domain(), [node.x, node.x + node.dx])
        return (t) =>
          @x.domain(xd(t))
          return tween(t)
      else
        return tween

    # When zooming: interpolate the scales.
    arcTweenZoom =  (d) =>
      interY = 0
      if d.y then interY = 20 else interY = 0
      yd = d3.interpolate(@y.domain(), [d.y, 1])
      yr = d3.interpolate(@y.range(), [interY, @radius])
      xd = d3.interpolate(@x.domain(), [d.x, d.x + d.dx], yd, yr)

      return (d, i) =>
        if i
          return (t) => 
            return @arc(d)
        else
          return (t) => 
            @x.domain(xd(t))
            @y.domain(yd(t)).range(yr(t)) 
            return @arc(d)


    click = (d) =>
      @node = d
      path.transition()
      .duration(1000)
      .attrTween("d", arcTweenZoom(d))

    # Magic function ;)
    mouseover = (d) =>
      #console.log 'called', d.name, d.id
      Session.set 'curTooltip', d.name
      
      if d.children
        Session.set 'curCat', d.name
      Session.set 'curQuestId', d.questionId
      Session.set 'curRespId', d.id

      @tooltip.style("visibility", "visible")

    path = @svg.datum(root).selectAll("path")
      .data(@partition.nodes)
      .enter().append("path")
      .attr("d", @arc)
      .style "fill", (d) => 
        item = null
#        if d.children then item = d else item = d.parent
#        return color(item.name)
        if d.children 
          return @color(d.name)
        if d.value
          value = parseInt(d.value)
          # console.log value, d
          switch 
            when value < 25 then return '#de2d26'
            when value >= 25 and value < 50 then return '#fc9272'
            when value is 50 then return '#e5f5e0'
            when value > 50 and value <= 75 then return  '#a1d99b'
            when value > 75 then return '#31a354'
            else
              return @color(d.name)

        else
          return @color(d.parent.name)
      .on("click", click)
      .on("mouseover", mouseover)      
      .each(stash)

    d3.selectAll("input").on "change", () =>
      if @value is 'count'
        value = ->
          return 1
      else
        value = (d) ->
          return d.size
      
      path.data @partition.value(value).nodes
        .transition()
        .duration(1000)
        .attrTween("d", arcTweenData)



    

