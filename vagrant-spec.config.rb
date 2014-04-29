Vagrant::Spec::Acceptance.configure do |c|
   c.component_paths << File.expand_path("../spec/acceptance", __FILE__)

  c.provider "azure",
    
    box: "D:/VagrantAzure/Acceptance Test/vagrant-azure-master/azuressh.box"
   
end
