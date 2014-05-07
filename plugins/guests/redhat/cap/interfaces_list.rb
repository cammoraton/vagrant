module VagrantPlugins
  module GuestRedHat
    module Cap
      class InterfacesList
        def self.interfaces_list(machine)
          version =  String.new
          machine.communicate.sudo("cat /etc/redhat-release | sed -e 's/.*release\ //' | cut -f1 -d' '") do |_, result|
            # Only care about the major version for now
            version = result.split('.').first
          end
          
          interface_names = Array.new

          # Only retrieve the list if we're in EL7+
          # Biosdevname was unreliably present in el6 and an ethX assumption was how it was done before
          if version.to_i> 6
            machine.communicate.sudo("biosdevname -d | grep Kernel | cut -f2 -d: | sed -e 's/ //;'") do |_, result|
              interface_names = result.split("\n")
            end
          end
          
          return interface_names
        end
      end
    end
  end
end