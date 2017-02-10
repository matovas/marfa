require 'marfa/cache'

describe Marfa::Cache do
  before(:all) do
    @cache = Marfa::Cache.new
    @key = 'cache_testing'
    @value = { key: 'value' }
  end

  it 'checks data setting' do
    @cache.set(@key, @value)
    expect(@cache.exist?(@key)).to be
  end

  it 'checks data getting' do
    data = @cache.get(@key)
    expect(data).to be
  end

  it 'checks data getting with wrong key' do
    data = @cache.get('some_unknown_key')
    expect(data).to be_nil
  end

  it 'checks data deleting' do
    @cache.delete(@key)
    expect(@cache.exist?(@key)).to eql false
  end

  it 'checks data deleting by pattern' do
    @cache.set(@key, @value)
    @cache.set(@key + '_1', @value)
    @cache.delete_by_pattern('testing')
    expect(@cache.exist?(@key)).to eql false
  end

  it 'checks_create_cache_key' do
    kind = 'block'
    path = 'offer/list'
    tags = %w(offers cities)
    cache_key = @cache.create_key(kind, path, tags)
    expect(cache_key.length).to satisfy { |len| len > 20 }
  end

  it 'checks_create_json_cache_key' do
    path = 'offer/list.json'
    cache_key = @cache.create_json_key(path)
    expect(cache_key.length).to eql path.length
  end
end