{split, take, join, lists-to-obj, sum, sort} = require 'prelude-ls'
sleep = (ms, f) -> set-interval f, ms
Ractive.DEBUG = /unminified/.test -> /*unminified*/

PieChart = Ractive.extend do
    template: '#pie-chart'
    oninit: ->
        col-list = @get \names |> split ','
        @set \columnList, col-list

    init:(options)->
        @animate 'c' , Math.PI*2
    data:
        selected: null
        names: null
        column-list: null
        c: 0
        colors: <[ red green blue yellow ]>
        getSegments:(data)->
            total = sum data
            data = sort data
            start=0
            segments = data.map (x)->
                size = x / total
                end = start + size
                segment=
                    value: x
                    start: start
                    end: end
                start:=end
                segment
            console.log "segments: ", segments
            segments

        getSegmentPoints:(segment, innerRadius, outerRadius)->
            points=[]
            start = segment.start * @get \c
            end = segment.end * @get \c
            getPoint=(angle,radius)->( ( radius * Math.sin( angle ) ).toFixed( 2 ) + ',' + ( radius * -Math.cos( angle ) ).toFixed( 2 ) )
            for angle from start to end by 0.05
                points[ points.length ] = getPoint angle, outerRadius
            points[ points.length ] = getPoint end, outerRadius
            for angle from end to start by -0.05
                points[ points.length ] = getPoint angle, innerRadius
            points[ points.length ] = getPoint start, innerRadius
            #console.log "test:" , points.join ' '
            return points.join ' '

kds-data=
    scores:
        *id:'score1'
         value:1
        *id:'score2'
         value:22
        *id:'score3'
         value: 55

ractive=new Ractive do
    el: '#main-output'
    template: '#main-template'
    data:
        kds:kds-data
        my-data: [3,5,7,99]
        my-data1: [4,5,12,1]
        my-data2: [213,5,2,5]
        x: kds-data.scores
    components:
        piechart: PieChart
