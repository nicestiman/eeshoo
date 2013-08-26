collection @posts
attributes :id, :species

child :author do
  attributes :id, :first, :last
end

child :group do
  attributes :id, :name, :location
end

child :contents do
  attributes :key, :value
end
