# # encoding: utf-8

# Inspec test for recipe mytomcat::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/
=begin
unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

# This is an example test, replace it with your own test.
describe port(80), :skip do
  it { should_not be_listening }
end
=end
#require 'spec_helper'

describe command("curl http://localhost:8080") do
  its(:stdout) { should match /Tomcat/ }
end

describe package ('java-1.7.0-openjdk-devel') do
 it {should be_installed}
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  it { should belong_to_group 'tomcat' }
  it { should have_home_directory '/opt/tomcat' }
end

describe file('/opt/tomcat') do
  it { should exist }
  it { should be_directory }
  it {should be_owned_by 'tomcat'}
end

#checking the permissions on webapps,work,temp,logs directories
%w[ conf webapps work temp logs].each do |path|
  describe file("/opt/tomcat/#{path}") do
    it { should exist }
    it { should be_mode 0755 }
    it { should be_owned_by 'tomcat'}
  end
end

=begin
describe file('/opt/tomcat/conf') do
  it { should exist }
  it { should be_mode 0755 }
  it {should be_owned_by 'tomcat'}
end


describe file('/opt/tomcat/conf') do
  it { should exist }
  it { should be_mode 755 }
  it {should be_owned_by 'tomcat'}
end

describe file('/opt/tomcat/webapps') do
  it { should exist }
  it { should be_mode 755 }
  it {should be_owned_by 'tomcat'}
end

describe file('/opt/tomcat/work') do
  it { should exist }
  it { should be_mode 755 }
  it {should be_owned_by 'tomcat'}
end

describe file('/opt/tomcat/temp') do
  it { should exist }
  it { should be_mode 755 }
  it {should be_owned_by 'tomcat'}
end

describe file('/opt/tomcat/logs') do
  it { should exist }
  it { should be_mode 755 }
  it {should be_owned_by 'tomcat'}
end
=end
