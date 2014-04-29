# This tests that synced folders work with a given provider.
shared_examples "provider/synced_folder" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("synced_folders")

    vagrantfile = environment.workdir.join('Vagrantfile')
    # TODO: Can we just shell out to something?
    new_vagrantfile = "Vagrant.require_plugin('vagrant-windows-hyperv')\n#{vagrantfile.read}"
    vagrantfile.open('w') { |f| f.puts(new_vagrantfile) }

    assert_execute("vagrant", "box", "add", "basic", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  # We put all of this in a single RSpec test so that we can test all
  # the cases within a single VM rather than having to `vagrant up` many
  # times.
  it "properly configures synced folder types" do
    status("Test: mounts the default /vagrant synced folder")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant/foo")
    expect(result.exit_code).to eql(0)
    expect(result.stdout).to match(/hello$/)

    status("Test: doesn't mount a disabled folder")
    result = execute("vagrant", "ssh", "-c", "test -d /foo")
    expect(result.exit_code).to eql(1)
  end
end
