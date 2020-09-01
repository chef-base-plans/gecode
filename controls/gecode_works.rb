title 'Tests to confirm gecode works as expected'

plan_origin = ENV['HAB_ORIGIN']
plan_name = input('plan_name', value: 'gecode')

control 'core-plans-gecode-works' do
  impact 1.0
  title 'Ensure gecode works as expected'
  desc '
  Verify gecode by ensuring that
  (1) its installation directory exists 
  (2) it returns the expected version
  '
  
  plan_installation_directory = command("hab pkg path #{plan_origin}/#{plan_name}")
  describe plan_installation_directory do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
    its('stderr') { should be_empty }
  end
  
  plan_pkg_version = plan_installation_directory.stdout.split("/")[5]
  ["fz"].each do |binary_name|
    command_full_path = File.join(plan_installation_directory.stdout.strip, "bin", binary_name)
    describe command("#{command_full_path} --help") do
      its('exit_status') { should eq 0 }
      its('stderr') { should_not be_empty }
      its('stderr') { should match /Version:\s+#{plan_pkg_version}/ }
      its('stdout') { should be_empty }
    end
  end
end