module VirtualBox
  class StorageController < AbstractModel
    attribute :name
    attribute :type
    attribute :max_ports, :populate_key => :maxportcount
    attribute :ports, :populate_key => :portcount
    
    class <<self
      def populate_relationship(caller, data)
        relation = []
        
        counter = 0
        loop do
          break unless data["storagecontrollername#{counter}".to_sym]
          nic = new(counter, data)
          relation.push(nic)
          counter += 1
        end
        
        relation
      end
      
      def save_relationship(caller, data)
      end
    end
    
    def initialize(index, data)
      super()
      
      @index = index
      
      # Setup the index specific attributes
      populate_data = {}
      self.class.attributes.each do |name, options|
        key = options[:populate_key] || name
        value = data["storagecontroller#{key}#{index}".to_sym]
        populate_data[key] = value
      end
      
      # Make sure to merge in device data so those relationships will be
      # setup properly
      populate_data.merge(extract_devices(index, data))
      
      populate_attributes(populate_data)
    end
    
    def extract_devices(index, data)
      name = data["storagecontrollername#{index}".to_sym]
      
      device_data = {}
      data.each do |k,v|
        next unless k.to_s =~ /^#{name}-/
        
        device_data[k] = v
      end
      
      device_data
    end
  end
end