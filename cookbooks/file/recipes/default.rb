
file "C:/tmp/helloworld.txt" do
  owner "vagrant"
  group "vagrant"
  mode 00544
  action :create
  content "Hello, Implementor! from cookbook it works"
end
	

# windows_package ".NET 4.0" do
  # package_name "Microsoft .NET Framework 4 Extended"
  # source "http://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe"
  # options "/q"
  # installer_type :inno
  # action :install
# end


