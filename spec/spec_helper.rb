$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sqlite3'
require 'active_record'
require 'simple_activemodel_validators'

ActiveRecord::Migration.verbose = false
