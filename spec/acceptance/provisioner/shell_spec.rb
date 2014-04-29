shared_examples "provider/provisioner/shell" do |provider, options|
  if !options[:box]
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("provisioner_shell")

    vagrantfile = environment.workdir.join('Vagrantfile')
    # TODO: Can we just shell out to something?
    new_vagrantfile = "Vagrant.require_plugin('vagrant-windows-hyperv')\n#{vagrantfile.read}"
    vagrantfile.open('w') { |f| f.puts(new_vagrantfile) }

    assert_execute("vagrant", "box", "add", "box", options[:box])
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "provisions with the shell script" do
    status("Test: inline script")
    result = execute("vagrant", "ssh", "-c", "cat /foo")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/foo\n$/)

    status("Test: script from path")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-path")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/bar\n$/)

    status("Test: script with args")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-args")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/hello\ntwo words\n$/)

    status("Test: privileged scripts")
    result = execute("vagrant", "ssh", "-c", "cat /tmp/vagrant-user-root")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/root$/)

    status("Test: non-privileged scripts")
    result = execute("vagrant", "ssh", "-c", "cat /tmp/vagrant-user")
    expect(result).to exit_with(0)
    expect(result.stdout).to_not match(/root$/)
  end
end
