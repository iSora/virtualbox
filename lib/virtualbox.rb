$:.unshift(File.expand_path(File.dirname(__FILE__)))
require 'virtualbox/errors'
require 'virtualbox/command'
require 'virtualbox/abstract_model'
require 'virtualbox/proxies/collection'
require 'virtualbox/image'
require 'virtualbox/attached_device'
require 'virtualbox/dvd'
require 'virtualbox/hard_drive'
require 'virtualbox/nic'
require 'virtualbox/storage_controller'
require 'virtualbox/vm'