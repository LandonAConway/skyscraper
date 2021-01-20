skyscraper.callbacks = {
  floor = {
    built = {},
    stage_changed = {},
    completed = {}
  },
  segment = {
    started = {},
    built = {},
    completed = {}
  },
  skyscraper = {
    initialized = {},
    started = {},
    built = {},
    completed = {}
  }
}

skyscraper.callback_functios = {}

function skyscraper.callback_functions.floor_built(skyscraperprog, segmentprog, floorprog)
  for i, v in ipairs(skyscraper.registered_floors) do
    v(skyscraperprog, segmentprog, floorprog)
  end
end

function skyscraper.callback_functions.stage_changed(skyscraperprog, segmentprog, floorprog, stagename)
  for i, v in ipairs(skyscraper.callbacks.floor.built) do
    v(skyscraperprog, segmentprog, floorprog, stagename)
  end
end

function skyscraper.callback_functions.floor_completed(skyscraperprog, segmentprog, floorprog)
  for i, v in ipairs(skyscraper.callbacks.floor.built) do
    v(skyscraperprog, segmentprog, floorprog)
  end
end

function skyscraper.callback_function.segment_started(skyscraperprog, segmentprog)
  for i, v in ipairs(skyscraper.callbacks.segment.started) do
    v(skyscraperprog, segmentprog)
  end
end

function skyscraper.callback_function.segment_built(skyscraperprog, segmentprog)
  for i, v in ipairs(skyscraper.callbacks.segment.built) do
    v(skyscraperprog, segmentprog)
  end
end

function skyscraper.callback_function.segment_completed(skyscraperprog, segmentprog)
  for i, v in ipairs(skyscraper.callbacks.segment.completed) do
    v(skyscraperprog, segmentprog)
  end
end

function skyscraper.callback_function.skyscraper_initialized(skyscraperprog, player)
  for i, v in ipairs(skyscraper.callbacks.skyscraper.initialized) do
    v(skyscraperprog, player)
  end
end

function skyscraper.callback_function.skyscraper_started(skyscraperprog)
  for i, v in ipairs(skyscraper.callbacks.skyscraper.started) do
    v(skyscraperprog)
  end
end

function skyscraper.callback_function.skyscraper_built(skyscraperprog)
  for i, v in ipairs(skyscraper.callbacks.skyscraper.built) do
    v(skyscraperprog)
  end
end

function skyscraper.callback_function.skyscraper_completed(skyscraperprog)
  for i, v in ipairs(skyscraper.callbacks.skyscraper.completed) do
    v(skyscraperprog)
  end
end