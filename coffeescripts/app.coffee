kue = require 'kue'
jobs = kue.createQueue()

kue.app.listen 3000

process = (job, done) ->
    progressMax = 100
    next = (i) ->
        console.log "#{job.data.title}(#{job.data.id}) [#{i}/#{progressMax}]"
        job.progress i, progressMax
        if i == progressMax
            done()
        else
            setTimeout ->
                next i+1
            , 100
    next 0

jobs.process 'hoge', process
jobs.process 'fuga', 3, process

jobs.create('hoge',
    title: 'hogehoge'
    id: i
).on('complete', ->
    console.log 'complete hoge'
).save() for i in [1..5]

jobs.create('fuga',
    title: 'fugafuga'
    id: i
).on('complete', ->
    console.log 'complete fuga'
).delay(5000).save() for i in [1..5]

jobs.promote 100 # default 5000(ms)