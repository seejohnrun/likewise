require 'bundler/setup'
require 'likewise'
require 'sinatra'
require 'json'

Likewise::store = Likewise::Store::Memcache.new

get '/:type/:value/:relation' do
  headers['content-type'] = 'application/json'
  key = "#{params[:type]}-#{params[:value]}-#{params[:relation]}"
  id = Digest::MD5.hexdigest(key)
  set = Likewise::SortedSet.find(id)
  # Return the set
  if set
    nodes = set.first(10)
    {
      :length => set.length,
      :top => nodes.map { |node| {
        :name => node[:name],
        :weight => node.link[:weight],
        :pct => node.link[:weight] / set.total_weight.to_f
      } }
    }.to_json
  else
    { :length => 0, :total_weight => 0, :top => [] }.to_json
  end
end
