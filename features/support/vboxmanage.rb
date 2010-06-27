class VBoxManage
  class << self
    def command(*args)
      args = args.dup.flatten
      args.unshift("-q")
      "VBoxManage #{args.join(" ")}"
    end

    def execute(*args)
      cmd = command(*args)
      result = `#{cmd}`.chomp
      raise Exception.new("Failed command: #{cmd}") if $?.exitstatus != 0
      result
    end

    # Gets the extra data for a VM of the given ID and returns it in
    # hash format.
    def extra_data(name)
      output = execute("getextradata", name, "enumerate")

      output.split("\n").inject({}) do |acc, line|
        acc[$1.to_s] = $2.to_s if line =~ /^Key: (.+?), Value: (.+?)$/
        acc
      end
    end

    # Gets the info for a VM and returns it in hash format.
    def vm_info(name)
      output = begin
        execute("showvminfo", name, "--machinereadable")
      rescue Exception
        ""
      end

      output.split("\n").inject({}) do |acc, line|
        if line =~ /^"?(.+?)"?=(.+?)$/
          key = $1.to_s
          value = $2.to_s
          value = $1.to_s if value =~ /^"(.*?)"$/
          acc[key] = value
        end

        acc
      end
    end

    # Parses the storage controllers out of VM info output and returns
    # it in a programmer-friendly hash.
    def storage_controllers(info)
      raw = info.inject({}) do |acc, data|
        k,v = data

        if k =~ /^storagecontroller(.+?)(\d+)$/
          subkey = $2.to_s
          acc[subkey] ||= {}
          acc[subkey][$1.to_s.to_sym] = v
        end

        acc
      end

      raw.inject({}) do |acc, data|
        k,v = data
        acc[v.delete(:name)] = v
        acc
      end
    end
  end
end
