require 'bundler/setup'
require 'likewise'
require 'sinatra'
require 'json'

Likewise::store = Likewise::Store::Memcache.new

get '/:type/:value/:relation' do
  headers['content-type'] = 'application/json'
  key = "#{params[:type]}-#{params[:value]}-#{params[:relation]}"
  time = Time.now
  id = Digest::MD5.hexdigest(key)
  set = Likewise::SortedSet.find(id)
  # Return the set
  if set
    nodes = set.first(10)
    {
      :time => Time.now - time,
      :length => set.length,
      :total_weight => set.total_weight,
      :top => nodes.map { |node| {
        :name => node[:name],
        :weight => node.context[:weight],
        :total => node[:weight],
        :pct_of_set => node.context[:weight] / set.total_weight.to_f,
        :pct_of_item => node.context[:weight] / node[:weight].to_f
      } }
    }.to_json
  else
    {
      :time => Time.now - time,
      :length => 0,
      :total_weight => 0,
      :top => []
    }.to_json
  end
end
