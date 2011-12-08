require File.dirname(__FILE__) + '/../lib/likewise'

# Allow tests to run over other storage types
if klass = ENV['STORAGE_CLASS']
  Likewise::store = eval("Likewise::Store::#{klass}").new
end
