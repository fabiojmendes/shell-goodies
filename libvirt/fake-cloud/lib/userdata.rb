require 'yaml'
require 'base64'

class UserData

  def initialize(hostname, default_password, public_ip, private_ip=public_ip)
    @hostname = hostname
	@default_password = default_password
    @public_ip =  public_ip
    @private_ip = private_ip
  end

  def generate
    write_files = []
    if !Dir["#{FAKE_CLOUD_HOME}/write.d"].empty?
      Dir.chdir "#{FAKE_CLOUD_HOME}/write.d" do
        Dir['**/*'].select{ |f| File.file?(f) }.each do |path|
          content = Base64.encode64(File.read(path))
          file = {
            'path' => "/#{path}",
            'encoding' => 'base64',
            'content' => content
          }
          write_files.push(file)
        end
      end
    end

    user_data = {
      'password' => @default_password,
      'chpasswd' => {
        'expire' => false
      },
      'write-files' => write_files
	}

    out = "#cloud-config\n"
    out << user_data.to_yaml
    return out
  end
end
