REDIS_STORE = Redis.new
I18n.backend = I18n::Backend::Chain.new(I18n::Backend::KeyValue.new(REDIS_STORE), I18n.backend)
