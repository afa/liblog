require 'spec_helper'
require 'import'
require 'fakeweb'

describe Import::Pull::Livejournal do
  before do
    FakeWeb.allow_net_connect = false
  end
  describe "when logining" do
    before do
      FakeWeb.register_uri(:post, 'http://www.livejournal.com/interface/xmlrpc', body: '<xml></xml>', status: [200, ''])
    end
    let(:login) { Import::Pull::Livejournal.lj_login('test', 'test') }
    it{ expect(login).to be }
    after do
      FakeWeb.clean_registry
    end
  end
  after do
    FakeWeb.allow_net_connect = true
  end
end
