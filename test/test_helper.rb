
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'shoulda'
require 'rack'
require 'rack/test'
require 'rack-zombieshotgun'

